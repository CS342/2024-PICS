//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

@testable import PICS
import XCTest

class PatientInformationTests: XCTestCase {
    // Test storing and retrieving dates
    func testStoreAndRetrieveDates() {
        let patientInformation = PatientInformation()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
        let testDate = Date()
        guard let threeMonthsAhead = calendar.date(byAdding: .month, value: 3, to: testDate) else {
            print("Error: Failed to calculate date three months ahead")
            return
        }

        guard let sixMonthsAhead = calendar.date(byAdding: .month, value: 6, to: testDate) else {
            print("Error: Failed to calculate date six months ahead")
            return
        }
        patientInformation.storeDates(testDate, threeMonthsAhead, sixMonthsAhead)

        let retrievedDate0 = patientInformation.appt0
        let retrievedDate1 = patientInformation.appt1
        let retrievedDate2 = patientInformation.appt2
    
        let testDateString = dateFormatter.string(from: testDate)
        let threeMonthsAheadString = dateFormatter.string(from: threeMonthsAhead)
        let sixMonthsAheadString = dateFormatter.string(from: sixMonthsAhead)
        let retrievedDate0String = dateFormatter.string(from: retrievedDate0)
        let retrievedDate1String = dateFormatter.string(from: retrievedDate1)
        let retrievedDate2String = dateFormatter.string(from: retrievedDate2)
        
        // Compare the formatted retrieved date with the formatted test date
        XCTAssertEqual(retrievedDate0String, testDateString)
        XCTAssertEqual(retrievedDate1String, threeMonthsAheadString)
        XCTAssertEqual(retrievedDate2String, sixMonthsAheadString)
    }
}
