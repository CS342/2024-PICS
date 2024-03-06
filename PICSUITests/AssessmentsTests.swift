//
// This source file is part of the PICS to test the health data dashboard.
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest

class AssessmentsTests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testAssessmentNavigation() {
        let app = XCUIApplication()
        
//        // Test if the Trail Making Test button exists and can be tapped
//        let trailMakingButton = app.buttons["ASSESSMENT_TM_START_BTN"]
//        XCTAssertTrue(trailMakingButton.waitForExistence(timeout: 2))
//        trailMakingButton.tap()
        // Now, test if the Trail Making Test button exists and can be tapped
        let trailMakingButton = app.buttons["startTrailMakingTestButton"]
        XCTAssertTrue(trailMakingButton.waitForExistence(timeout: 2), "Trail Making Test button should exist")
        trailMakingButton.tap()
    }
}
