//
// This source file is part of the PICS to test the health data dashboard.
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTHealthKit

class HealthVisualizationTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]

        app.launch()
    }
    
    
    func testLoadHealthDashboard() throws {
        // Check whether the components shows as expected.
        let app = XCUIApplication()
        // Go to the Health dashboard.
        XCTAssertTrue(app.buttons["Health"].waitForExistence(timeout: 2))
        app.buttons["Health"].tap()

        XCTAssertTrue(app.staticTexts["Heart Rate"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Oxygen Saturation (%)"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Step Count"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Health Dashboard"].waitForExistence(timeout: 2))
    }
}
