//
// This source file is part of the PICS to show patients' health data.
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//


import Charts
import Foundation
import HealthKit
import SwiftUI

struct HKData: Identifiable {
    var date: Date
    var id = UUID()
    var sumValue: Double
    var avgValue: Double
    var minValue: Double
    var maxValue: Double
}

struct HKVisualization: View {
    @Environment(PatientInformation.self)
    private var patientInformation

    @State var stepData: [HKData] = []
    @State var heartRateData: [HKData] = []
    @State var oxygenSaturationData: [HKData] = []
    @State var heartRateScatterData: [HKData] = []
    @State var oxygenSaturationScatterData: [HKData] = []

    var visualizationList: some View {
        self.readAllHKData()
        return List {
            Section {
                HKVisualizationItem(
                    data: self.stepData,
                    xName: "Time",
                    yName: "Step Count",
                    title: "HKVIZ_PLOT_STEP_TITLE",
                    threshold: Double(patientInformation.minimumStepCount),
                    helperText: "HKVIZ_PLOT_STEP_RECOMD"
                )
            }
            Section {
                HKVisualizationItem(
                    data: self.heartRateData,
                    xName: "Time",
                    yName: "Heart Rate Per Minute",
                    title: "HKVIZ_PLOT_HEART_TITLE",
                    scatterData: self.heartRateScatterData
                )
            }
            Section {
                HKVisualizationItem(
                    data: self.oxygenSaturationData,
                    xName: "Time",
                    yName: "Oxygen Saturation (precent)",
                    title: "HKVIZ_PLOT_OXYGEN_TITLE",
                    threshold: 94.0,
                    helperText: "HKVIZ_PLOT_OXYGEN_RECOMD",
                    scatterData: self.oxygenSaturationScatterData
                )
            }
        }
    }
    
    @Binding var presentingAccount: Bool
    
    var body: some View {
        self.readAllHKData()
        
        return NavigationStack {
            visualizationList
                .navigationTitle("HKVIZ_NAVIGATION_TITLE")
                .toolbar {
                    if AccountButton.shouldDisplay {
                        AccountButton(isPresented: $presentingAccount)
                    }
                }
                .onAppear {
                    // Ensure that the data are up-to-date when the view is activated.
                    self.readAllHKData(ensureUpdate: true)
                }
        }
    }
    
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
    
    func loadMockData() {
        // Load the mock data for testing purposes to the states.
        let today = Date()
        let sumStatData = [
            HKData(date: today, sumValue: 100, avgValue: 0, minValue: 0, maxValue: 0),
            HKData(date: today, sumValue: 100, avgValue: 0, minValue: 0, maxValue: 0)
        ]
        let minMaxAvgStatData = [
            HKData(date: today, sumValue: 0, avgValue: 50, minValue: 1, maxValue: 100)
        ]
        if self.stepData.isEmpty {
            self.stepData = sumStatData
            self.heartRateScatterData = sumStatData
            self.oxygenSaturationScatterData = sumStatData
            self.heartRateData = minMaxAvgStatData
            self.oxygenSaturationData = minMaxAvgStatData
        }
    }
    
    func readAllHKData(ensureUpdate: Bool = false) {
        if FeatureFlags.mockTestData {
            // Use the mockData directly and no need to query HK data.
            loadMockData()
            return
        }
        
        // Generate the dates and predicates for all HealthKit queries.
        let startOfToday: Date = Calendar.current.startOfDay(for: Date())
        guard let endDate = Calendar.current.date(byAdding: DateComponents(hour: 23, minute: 59, second: 59), to: startOfToday) else {
            fatalError("*** Unable to create an end date ***")
        }
        // Collect data for the previous two weeks.
        guard let startDate = Calendar.current.date(byAdding: .day, value: -14, to: endDate) else {
            fatalError("*** Unable to create a start date ***")
        }
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        // Read step counts perday seperately with statistics query.
        if self.stepData.isEmpty || ensureUpdate {
            self.readHKStats(
                startDate: startDate,
                endDate: endDate,
                predicate: predicate,
                quantityTypeIDF: HKQuantityTypeIdentifier.stepCount
            )
        }
        // Read the heart rate and oxygen saturation data.
        if self.heartRateData.isEmpty || ensureUpdate {
            self.readHKStats(
                startDate: startDate,
                endDate: endDate,
                predicate: predicate,
                quantityTypeIDF: HKQuantityTypeIdentifier.heartRate
            )
            self.readFromSampleQuery(
                startDate: startDate,
                endDate: endDate,
                predicate: predicate,
                quantityTypeIDF: HKQuantityTypeIdentifier.heartRate
            )
        }
        if self.oxygenSaturationData.isEmpty || ensureUpdate {
            self.readHKStats(
                startDate: startDate,
                endDate: endDate,
                predicate: predicate,
                quantityTypeIDF: HKQuantityTypeIdentifier.oxygenSaturation
            )
            self.readFromSampleQuery(
                startDate: startDate,
                endDate: endDate,
                predicate: predicate,
                quantityTypeIDF: HKQuantityTypeIdentifier.oxygenSaturation
            )
        }
    }
    
    func readFromSampleQuery(
         startDate: Date,
         endDate: Date,
         predicate: NSPredicate,
         quantityTypeIDF: HKQuantityTypeIdentifier
     ) {
         let healthStore = HKHealthStore()
         // Run a HKSampleQuery to fetch the health kit data.
         guard let quantityType = HKObjectType.quantityType(forIdentifier: quantityTypeIDF) else {
             fatalError("*** Unable to create a quantity type ***")
         }
         let sortDescriptors = [
             NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
         ]
         let query = HKSampleQuery(
             sampleType: quantityType,
             predicate: predicate,
             limit: Int(HKObjectQueryNoLimit),
             sortDescriptors: sortDescriptors
         ) { _, results, error in
             guard error == nil else {
                 print("Error retrieving health kit data: \(String(describing: error))")
                 return
             }
             if let results = results {
                 // Retrieve quantity value and time for each data point.
                 let collectedData = parseSampleQueryData(results: results, quantityTypeIDF: quantityTypeIDF)
                 if quantityTypeIDF == HKQuantityTypeIdentifier.oxygenSaturation {
                     self.oxygenSaturationScatterData = collectedData
                 } else if quantityTypeIDF == HKQuantityTypeIdentifier.heartRate {
                     self.heartRateScatterData = collectedData
                 }
             }
         }
         healthStore.execute(query)
     }
    
    func readHKStats(
        startDate: Date,
        endDate: Date,
        predicate: NSPredicate,
        quantityTypeIDF: HKQuantityTypeIdentifier
    ) {
        let healthStore = HKHealthStore()
        // Read the step counts per day for the past three months.
        guard let quantityType = HKObjectType.quantityType(forIdentifier: quantityTypeIDF) else {
            fatalError("*** Unable to create a quantity type ***")
        }
        let query = if quantityTypeIDF == HKQuantityTypeIdentifier.stepCount {
            HKStatisticsCollectionQuery(
                quantityType: quantityType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum,
                anchorDate: startDate,
                intervalComponents: DateComponents(day: 1)
            )
        } else {
            HKStatisticsCollectionQuery(
                quantityType: quantityType,
                quantitySamplePredicate: predicate,
                options: [.discreteMax, .discreteMin, .discreteAverage],
                anchorDate: startDate,
                intervalComponents: DateComponents(day: 1)
            )
        }
        query.initialResultsHandler = { _, results, error in
            guard error == nil else {
                print("Error retrieving health kit data: \(String(describing: error))")
                return
            }
            if let results = results {
                updateQueryResult(results: results, startDate: startDate, endDate: endDate, quantityTypeIDF: quantityTypeIDF)
            }
        }
        healthStore.execute(query)
    }
    
    func updateQueryResult(
        results: HKStatisticsCollection,
        startDate: Date,
        endDate: Date,
        quantityTypeIDF: HKQuantityTypeIdentifier
    ) {
        var allData: [HKData] = []
        // Enumerate over all the statistics objects between the start and end dates.
        results.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
            if let curHKData = parseStat(statistics: statistics, quantityTypeIDF: quantityTypeIDF) {
                allData.append(curHKData)
            }
        }
        
        switch quantityTypeIDF {
        case .stepCount:
            self.stepData = allData
        case .oxygenSaturation:
            self.oxygenSaturationData = allData
        case .heartRate:
            self.heartRateData = allData
        default:
            print("Unexpected quantity received:", quantityTypeIDF)
        }
    }
    
    func parseStat(statistics: HKStatistics, quantityTypeIDF: HKQuantityTypeIdentifier) -> HKData? {
        let date = statistics.endDate
        var curSum = 0.0
        var curMax = 0.0
        var curAvg = 0.0
        var curMin = 0.0
        if let quantity = statistics.sumQuantity() {
            curSum = parseValue(quantity: quantity, quantityTypeIDF: quantityTypeIDF)
        }
        if let quantity = statistics.maximumQuantity() {
            curMax = parseValue(quantity: quantity, quantityTypeIDF: quantityTypeIDF)
        }
        if let quantity = statistics.averageQuantity() {
            curAvg = parseValue(quantity: quantity, quantityTypeIDF: quantityTypeIDF)
        }
        if let quantity = statistics.minimumQuantity() {
            curMin = parseValue(quantity: quantity, quantityTypeIDF: quantityTypeIDF)
        }
        if curSum != 0.0 || curMin != 0.0 || curMin != 0.0 || curMax != 0.0 {
            return HKData(date: date, sumValue: curSum, avgValue: curAvg, minValue: curMin, maxValue: curMax)
        }
        return nil
    }
}

func parseValue(quantity: HKQuantity, quantityTypeIDF: HKQuantityTypeIdentifier) -> Double {
    switch quantityTypeIDF {
    case .stepCount:
        return quantity.doubleValue(for: .count())
    case .oxygenSaturation:
        return quantity.doubleValue(for: .percent()) * 100
    case .heartRate:
        return quantity.doubleValue(for: HKUnit(from: "count/min"))
    default:
        print("Unexpected quantity received:", quantityTypeIDF)
        return -1.0
    }
}

func parseSampleQueryData(results: [HKSample], quantityTypeIDF: HKQuantityTypeIdentifier) -> [HKData] {
    // Retrieve quantity value and time for each data point.
    var collectedData: [HKData] = []
    for result in results {
        guard let result: HKQuantitySample = result as? HKQuantitySample else {
            print("Unexpected HK Quantity sample received.")
            continue
        }
        var value = -1.0 // To be replaced below.
        if quantityTypeIDF == HKQuantityTypeIdentifier.oxygenSaturation {
            value = result.quantity.doubleValue(for: HKUnit.percent()) * 100
        } else if quantityTypeIDF == HKQuantityTypeIdentifier.heartRate {
            value = result.quantity.doubleValue(for: HKUnit(from: "count/min"))
        }
        let date = result.startDate
        collectedData.append(HKData(date: date, sumValue: value, avgValue: -1.0, minValue: -1.0, maxValue: -1.0))
    }
    return collectedData
}


#if DEBUG
#Preview {
    HKVisualization(presentingAccount: .constant(false))
        .environment(PatientInformation())
}
#endif
