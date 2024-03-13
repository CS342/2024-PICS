//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest
@testable import PICS

class AppointmentInformationTests: XCTestCase {
    
    // Test storing and retrieving dates
    func testStoreAndRetrieveDates() {
        let appointmentInformation = AppointmentInformation()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
        let testDate = Date()
        let threeMonthsAhead = calendar.date(byAdding: .month, value: 3, to: testDate)!
        let sixMonthsAhead = calendar.date(byAdding: .month, value: 6, to: testDate)!
        appointmentInformation.storeDates(testDate, threeMonthsAhead, sixMonthsAhead)
        
        let retrievedDate0 = appointmentInformation.appt0
        let retrievedDate1 = appointmentInformation.appt1
        let retrievedDate2 = appointmentInformation.appt2
    
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
