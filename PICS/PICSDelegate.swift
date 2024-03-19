//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziAccount
import SpeziFirebaseAccount
import SpeziFirebaseStorage
import SpeziFirestore
import SpeziHealthKit
import SpeziOnboarding
import SpeziScheduler
import SwiftUI


class PICSDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: PICSStandard()) {
            if !FeatureFlags.disableFirebase {
                AccountConfiguration(configuration: [
                    .requires(\.userId),
                    .requires(\.name)
                ])

                if FeatureFlags.useFirebaseEmulator {
                    FirebaseAccountConfiguration(
                        authenticationMethods: [.emailAndPassword, .signInWithApple],
                        emulatorSettings: (host: "localhost", port: 9099)
                    )
                } else {
                    FirebaseAccountConfiguration(authenticationMethods: [.emailAndPassword, .signInWithApple])
                }
                firestore
                if FeatureFlags.useFirebaseEmulator {
                    FirebaseStorageConfiguration(emulatorSettings: (host: "localhost", port: 9199))
                } else {
                    FirebaseStorageConfiguration()
                }
            }

            if HKHealthStore.isHealthDataAvailable() {
                healthKit
            }
            
            PICSScheduler()
            OnboardingDataSource()
        }
    }
    
    
    private var firestore: Firestore {
        let settings = FirestoreSettings()
        if FeatureFlags.useFirebaseEmulator {
            settings.host = "localhost:8080"
            settings.cacheSettings = MemoryCacheSettings()
            settings.isSSLEnabled = false
        }
        
        return Firestore(
            settings: settings
        )
    }

    // Currently, we collect data for the past month. In the future, we might
    // change this to collecting data since three months before the first
    // or the closest incoming appointment if we collect the appointment dates
    // and able to access those data here.
    private var monthTraceBack = -1
    
    private var predicateThreeMonth: NSPredicate {
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.startOfDay(for: Date())
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: today) else {
            fatalError("*** Unable to calculate the end time ***")
        }
        guard let startDate = calendar.date(byAdding: .month, value: monthTraceBack, to: endDate) else {
            fatalError("*** Unable to calculate the start time ***")
        }
        return HKQuery.predicateForSamples(withStart: startDate, end: endDate)
    }
    
    private var healthKit: HealthKit {
        HealthKit {
            // PICS needs to collect Heart Rate every 10 minutes, Oxygen Saturation every
            // 10 minutes, and Step Count daily.
            CollectSample(
                HKQuantityType(.stepCount),
                predicate: predicateThreeMonth,
                deliverySetting: .background(.automatic)
            )
            CollectSample(
                HKQuantityType(.heartRate),
                predicate: predicateThreeMonth,
                deliverySetting: .background(.automatic)
            )
            CollectSample(
                HKQuantityType(.oxygenSaturation),
                predicate: predicateThreeMonth,
                deliverySetting: .background(.automatic)
            )
        }
    }
}
