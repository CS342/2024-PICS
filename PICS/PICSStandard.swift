//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseFirestore
import FirebaseStorage
import HealthKitOnFHIR
import OSLog
import PDFKit
import Spezi
import SpeziAccount
import SpeziFirebaseAccountStorage
import SpeziFirestore
import SpeziHealthKit
import SpeziOnboarding
import SpeziQuestionnaire
import SwiftUI


actor PICSStandard: Standard, EnvironmentAccessible, HealthKitConstraint, OnboardingConstraint, AccountStorageConstraint {
    enum PICSStandardError: Error {
        case userNotAuthenticatedYet
    }
    
    // For HealthKit data stored as document in the firebase.
    struct HKFirebaseDoc: Codable {
      var startDate: Date
      var endDate: Date
      var value: Double
    }

    private static var userCollection: CollectionReference {
        Firestore.firestore().collection("users")
    }

    @Dependency var accountStorage: FirestoreAccountStorage?

    @AccountReference var account: Account

    private let logger = Logger(subsystem: "PICS", category: "Standard")
    
    
    private var userDocumentReference: DocumentReference {
        get async throws {
            guard let details = await account.details else {
                throw PICSStandardError.userNotAuthenticatedYet
            }

            return Self.userCollection.document(details.accountId)
        }
    }
    
    private var userBucketReference: StorageReference {
        get async throws {
            guard let details = await account.details else {
                throw PICSStandardError.userNotAuthenticatedYet
            }

            return Storage.storage().reference().child("users/\(details.accountId)")
        }
    }


    init() {
        if !FeatureFlags.disableFirebase {
            _accountStorage = Dependency(wrappedValue: FirestoreAccountStorage(storeIn: PICSStandard.userCollection))
        }
    }


    func add(sample: HKSample) async {
        guard !FeatureFlags.disableFirebase else {
            return
        }

        await parseAndAddHkData(sample: sample)
    }
    
    func parseAndAddHkData(sample: HKSample) async {
        // Currently, we only want to query step counts, heartrate, and oxygen staturation,
        // which are all collected through type HKQuantitySample.
        guard let sampleData: HKQuantitySample = sample as? HKQuantitySample else {
            logger.warning("Unexpected HK sample type found: \(sample.sampleType). Saved the original data.")
            await saveRawHKSample(sample: sample)
            return
        }
        let startDate = sampleData.startDate
        let endDate = sampleData.endDate
        var value = -1.0 // The value to be replaced in below.
        var collectionName = "HealthKit"
        
        switch sampleData.quantityType {
        case HKQuantityType(.stepCount):
            value = sampleData.quantity.doubleValue(for: HKUnit.count())
            collectionName += "StepCount"
        case HKQuantityType(.oxygenSaturation):
            value = sampleData.quantity.doubleValue(for: HKUnit.percent()) * 100
            collectionName += "OxygenSaturation"
        case HKQuantityType(.heartRate):
            value = sampleData.quantity.doubleValue(for: HKUnit(from: "count/min"))
            collectionName += "HeartRate"
        default:
            logger.warning("Unexpected HK quantity sample type found: \(sampleData.quantityType). Saved the original data")
            await saveRawHKSample(sample: sample)
            return
        }
        
        let data = HKFirebaseDoc(startDate: startDate, endDate: endDate, value: value)
        do {
            try await healthKitDocument(id: sample.id, collectionName: collectionName).setData(from: data)
        } catch {
            logger.error("Could not store HealthKit sample: \(error)")
        }
    }
    
    func remove(sample: HKDeletedObject) async {
        guard !FeatureFlags.disableFirebase else {
            return
        }

        do {
            try await healthKitDocument(id: sample.uuid).delete()
        } catch {
            logger.error("Could not remove HealthKit sample: \(error)")
        }
    }
    
    func add(response: ModelsR4.QuestionnaireResponse) async {
        let id = response.identifier?.value?.value?.string ?? UUID().uuidString
        
        guard !FeatureFlags.disableFirebase else {
            return
        }
        
        do {
            try await userDocumentReference
                .collection("QuestionnaireResponse") // Add all HealthKit sources in a /QuestionnaireResponse collection.
                .document(id) // Set the document identifier to the id of the response.
                .setData(from: response)
        } catch {
            logger.error("Could not store questionnaire response: \(error)")
        }
    }
    
    
    private func healthKitDocument(id uuid: UUID, collectionName: String = "HealthKit") async throws -> DocumentReference {
        try await userDocumentReference
            .collection(collectionName) // Add all HealthKit sources in a /HealthKit collection.
            .document(uuid.uuidString) // Set the document identifier to the UUID of the document.
    }
    
    private func saveRawHKSample(sample: HKSample) async {
        do {
            try await healthKitDocument(id: sample.id).setData(from: sample.resource)
        } catch {
            logger.error("Could not store HealthKit sample: \(error)")
        }
    }

    func deletedAccount() async throws {
        // delete all user associated data
        do {
            try await userDocumentReference.delete()
        } catch {
            logger.error("Could not delete user document: \(error)")
        }
    }
    
    /// Stores the given consent form in the user's document directory with a unique timestamped filename.
    ///
    /// - Parameter consent: The consent form's data to be stored as a `PDFDocument`.
    func store(consent: PDFDocument) async {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HHmmss"
        let dateString = formatter.string(from: Date())
        
        guard !FeatureFlags.disableFirebase else {
            guard let basePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                logger.error("Could not create path for writing consent form to user document directory.")
                return
            }
            
            let filePath = basePath.appending(path: "consentForm_\(dateString).pdf")
            consent.write(to: filePath)
            
            return
        }
        
        do {
            guard let consentData = consent.dataRepresentation() else {
                logger.error("Could not store consent form.")
                return
            }
            
            let metadata = StorageMetadata()
            metadata.contentType = "application/pdf"
            _ = try await userBucketReference.child("consent/\(dateString).pdf").putDataAsync(consentData, metadata: metadata)
        } catch {
            logger.error("Could not store consent form: \(error)")
        }
    }
    
    func storeImage(image: PDFDocument) async {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HHmmss"
        let dateString = formatter.string(from: Date())
        
        guard !FeatureFlags.disableFirebase else {
            guard let basePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                logger.error("Could not create path for storing medication plan.")
                return
            }
            
            let filePath = basePath.appending(path: "medicationPlan_\(dateString).pdf")
            image.write(to: filePath)
            
            return
        }
        
        do {
            guard let medicationData = image.dataRepresentation() else {
                logger.error("Could not store medication plan.")
                return
            }
            
            let metadata = StorageMetadata()
            metadata.contentType = "application/pdf"
            _ = try await userBucketReference.child("medicationPlan/\(dateString).pdf").putDataAsync(medicationData, metadata: metadata)
        } catch {
            logger.error("Could not store medication plan: \(error)")
        }
    }


    func create(_ identifier: AdditionalRecordId, _ details: SignupDetails) async throws {
        guard let accountStorage else {
            preconditionFailure("Account Storage was requested although not enabled in current configuration.")
        }
        try await accountStorage.create(identifier, details)
    }

    func load(_ identifier: AdditionalRecordId, _ keys: [any AccountKey.Type]) async throws -> PartialAccountDetails {
        guard let accountStorage else {
            preconditionFailure("Account Storage was requested although not enabled in current configuration.")
        }
        return try await accountStorage.load(identifier, keys)
    }

    func modify(_ identifier: AdditionalRecordId, _ modifications: AccountModifications) async throws {
        guard let accountStorage else {
            preconditionFailure("Account Storage was requested although not enabled in current configuration.")
        }
        try await accountStorage.modify(identifier, modifications)
    }

    func clear(_ identifier: AdditionalRecordId) async {
        guard let accountStorage else {
            preconditionFailure("Account Storage was requested although not enabled in current configuration.")
        }
        await accountStorage.clear(identifier)
    }

    func delete(_ identifier: AdditionalRecordId) async throws {
        guard let accountStorage else {
            preconditionFailure("Account Storage was requested although not enabled in current configuration.")
        }
        try await accountStorage.delete(identifier)
    }
}
