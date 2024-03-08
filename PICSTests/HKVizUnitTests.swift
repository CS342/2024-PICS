//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import HealthKit
@testable import PICS
import XCTest


class HKVizUnitTests: XCTestCase {
    // Test the parseValue function by manually creating HKQuantity and parse it.
    func testHKParseValue() throws {
        let stepQuantity = HKQuantity(unit: .count(), doubleValue: 10)
        XCTAssertEqual(parseValue(quantity: stepQuantity, quantityTypeIDF: .stepCount), 10)
        
        let osQuantity = HKQuantity(unit: .percent(), doubleValue: 0.9)
        XCTAssertEqual(parseValue(quantity: osQuantity, quantityTypeIDF: .oxygenSaturation), 90)
        
        let hrQuantity = HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: 10)
        XCTAssertEqual(parseValue(quantity: hrQuantity, quantityTypeIDF: .heartRate), 10)
        
        // Unexpected quantity returns -1.
        XCTAssertEqual(parseValue(quantity: hrQuantity, quantityTypeIDF: .bodyMass), -1)
    }
    
    // Test updateSampleQueryData function by manually creating HKSample and parse it.
    func testHKUpdateSampleQueryData() throws {
        // This function only support oxygen saturation and heart rate so we only need to test them.
        let date = Date()
        // Testing parsing the oxygen saturation samples.
        let osQuantityType = HKQuantityType(.oxygenSaturation)
        var osSamples: [HKSample] = []
        let pcts = [0.9, 0.95, 0.98]
        for val in pcts {
            let osQuantity = HKQuantity(unit: .percent(), doubleValue: val)
            let osQS: HKSample = HKQuantitySample(type: osQuantityType, quantity: osQuantity, start: date, end: date)
            osSamples.append(osQS)
        }
        var dataParsed = parseSampleQueryData(results: osSamples, quantityTypeIDF: .oxygenSaturation)
        for (parsed, pct) in zip(dataParsed, pcts) {
            XCTAssertEqual(parsed.date, date)
            XCTAssertEqual(parsed.sumValue, pct * 100)
            XCTAssertEqual(parsed.avgValue, -1)
            XCTAssertEqual(parsed.minValue, -1)
            XCTAssertEqual(parsed.minValue, -1)
        }
        // Testing parsing the heart rate samples.
        let hrQuantityType = HKQuantityType(.heartRate)
        var hrSamples: [HKSample] = []
        let hrs = [50, 55, 60]
        for val in hrs {
            let hrQuantity = HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: Double(val))
            let hrQS: HKSample = HKQuantitySample(type: hrQuantityType, quantity: hrQuantity, start: date, end: date)
            hrSamples.append(hrQS)
        }
        dataParsed = parseSampleQueryData(results: hrSamples, quantityTypeIDF: .heartRate)
        for (parsed, val) in zip(dataParsed, hrs) {
            XCTAssertEqual(parsed.date, date)
            XCTAssertEqual(parsed.sumValue, Double(val))
            XCTAssertEqual(parsed.avgValue, -1)
            XCTAssertEqual(parsed.minValue, -1)
            XCTAssertEqual(parsed.minValue, -1)
        }
    }
}
