//
//  HKVisualization.swift
//  PICS
//
//  Created by Yuren Sun on 2024/2/2.
//


import Charts
import HealthKit
import SwiftUI

struct HKData: Identifiable {
    var date: Date
    var value: Double
    var id = UUID()
}

struct HKVisualization: View {
    let healthStore = HKHealthStore()
    @State var stepData: [HKData] = []
    @State var heartRateData: [HKData] = []
    @State var oxygenSaturationData: [HKData] = []
    
    var visualizationList: some View {
        self.readAllHKData()
        return List {
            Section {
                HKVisualizationItem(
                    data: self.stepData,
                    xName: "Time",
                    yName: "Step Count",
                    title: "Step Data"
                )
            }
            Section {
                HKVisualizationItem(
                    data: self.heartRateData,
                    xName: "Time",
                    yName: "Heart Rate Per Minute",
                    title: "Heart Rate"
                )
            }
            Section {
                HKVisualizationItem(
                    data: self.oxygenSaturationData,
                    xName: "Time",
                    yName: "Oxygen Saturation (precent)",
                    title: "Oxygen Saturation"
                )
            }
        }
    }
    
    @Binding var presentingAccount: Bool
    
    var body: some View {
        self.readAllHKData()
        
        return NavigationStack {
            visualizationList
                .navigationTitle(String(localized: "HKVIZ_NAVIGATION_TITLE"))
                .toolbar {
                    if AccountButton.shouldDisplay {
                        AccountButton(isPresented: $presentingAccount)
                    }
                }
        }
    }
    
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
    
    func readAllHKData() {
        // Generate the dates and predicates for all HealthKit queries.
        let endDate = Date()
        guard let startDate = Calendar.current.date(byAdding: .day, value: -14, to: endDate) else {
            fatalError("*** Unable to create a start date ***")
        }
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        // Read step counts perday seperately with statistics query.
        self.readStepCountStats(startDate: startDate, endDate: endDate, predicate: predicate)
        // Read the heart rate and oxygen saturation data.
        readFromSampleQuery(
            startDate: startDate,
            endDate: endDate,
            predicate: predicate,
            quantityTypeIDF: HKQuantityTypeIdentifier.heartRate
        )
        readFromSampleQuery(
            startDate: startDate,
            endDate: endDate,
            predicate: predicate,
            quantityTypeIDF: HKQuantityTypeIdentifier.oxygenSaturation
        )
    }
    
    func readFromSampleQuery(
        startDate: Date,
        endDate: Date,
        predicate: NSPredicate,
        quantityTypeIDF: HKQuantityTypeIdentifier
    ) {
        // Run a HKSampleQuery to fetch the health kit data.
        guard let quantityType = HKObjectType.quantityType(forIdentifier: quantityTypeIDF) else {
            fatalError("*** Unable to create a step count type ***")
        }
        let sortDescriptors = [
            NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        ]
        let query = HKSampleQuery(
            sampleType: quantityType,
            predicate: predicate,
            limit: 2000,
            sortDescriptors: sortDescriptors
        ) { _, results, error -> Void in
            guard error == nil else {
                print(print("Error retrieving health kit data: \(String(describing: error))"))
                return
            }
            if let results = results {
                // Retrieve quantity value and time for each data point.
                var collectedData: [HKData] = []
                for result in results {
                    guard let result: HKQuantitySample = result as? HKQuantitySample else {
                        print("Unexpected heart rate sample type received.")
                        continue
                    }
                    var value = -1.0 // To be replaced below.
                    if quantityTypeIDF == HKQuantityTypeIdentifier.oxygenSaturation {
                        value = result.quantity.doubleValue(for: HKUnit.percent()) * 100
                    } else if quantityTypeIDF == HKQuantityTypeIdentifier.heartRate {
                        value = result.quantity.doubleValue(for: HKUnit(from: "count/min"))
                    }
                    let date = result.startDate
                    collectedData.append(HKData(date: date, value: value))
                }
                if quantityTypeIDF == HKQuantityTypeIdentifier.oxygenSaturation {
                    self.oxygenSaturationData = collectedData
                } else if quantityTypeIDF == HKQuantityTypeIdentifier.heartRate {
                    self.heartRateData = collectedData
                }
            }
        }
        healthStore.execute(query)
    }
    
    func readStepCountStats(startDate: Date, endDate: Date, predicate: NSPredicate) {
        // Read the step counts per day for the past three months.
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            fatalError("*** Unable to create a step count type ***")
        }
        let query = HKStatisticsCollectionQuery(
            quantityType: quantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: startDate,
            intervalComponents: DateComponents(day: 1)
        )
        query.initialResultsHandler = { _, results, error in
            guard error == nil else {
                print(print("Error retrieving health kit data: \(String(describing: error))"))
                return
            }
            if let results = results {
                updateStepCountResult(results: results, startDate: startDate, endDate: endDate)
            }
        }
        healthStore.execute(query)
    }
    
    func updateStepCountResult(results: HKStatisticsCollection, startDate: Date, endDate: Date) {
        var stepData: [HKData] = []
        // Enumerate over all the statistics objects between the start and end dates.
        results.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
            if let quantity = statistics.sumQuantity() {
                let date = statistics.startDate
                let value = quantity.doubleValue(for: .count())
                stepData.append(HKData(date: date, value: value))
            }
        }
        self.stepData = stepData
    }
}


#if DEBUG
#Preview {
    HKVisualization(presentingAccount: .constant(false))
}
#endif