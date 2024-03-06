//
// This source file is part of the PICS to test the health data dashboard.
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest

final class AssessmentsUITests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.launch()
    }
    func testAssessmentsViewLoads() throws {
        let app = XCUIApplication()
        
        // Navigate to the Assessments view
        app.buttons["Assessments"].tap()
        
        // Assert that the Assessments view is displayed
        XCTAssertTrue(app.staticTexts["ASSESSMENTS_NAVIGATION_TITLE"].waitForExistence(timeout: 2))
        
        // Assert that the Trail Making and Stroop Test sections are displayed
        XCTAssertTrue(app.staticTexts["Trail Making"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Stroop Test"].waitForExistence(timeout: 2))
    }
}
