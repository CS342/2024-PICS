//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest


class AppoinmentsTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.launch()
    }
    
    func testApplicationLaunch() throws {
        let app = XCUIApplication()
        // checks that you can access the tab and view renders
        XCTAssertTrue(app.buttons["Appointments"].waitForExistence(timeout: 2))
        app.buttons["Appointments"].tap()
        XCTAssertTrue(app.buttons["Edit Details"].waitForExistence(timeout: 2))
        app.buttons["Edit Details"].tap()
        XCTAssertTrue(app.buttons["Save Changes"].waitForExistence(timeout: 2))
        app.buttons["Save Changes"].tap()
        XCTAssertTrue(app.buttons["Required Items"].waitForExistence(timeout: 2))
        let firstButton = try XCTUnwrap(app.buttons.matching(identifier: "Required Items").allElementsBoundByIndex.first)
        firstButton.tap()
        XCTAssertTrue(app.buttons["Close"].waitForExistence(timeout: 2))
        app.navigationBars["Required Items"].buttons["Close"].tap()
    }
}
