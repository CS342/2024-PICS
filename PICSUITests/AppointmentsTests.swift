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
        // checks contents of tab
        XCTAssertTrue(app.staticTexts["Getting Here"].waitForExistence(timeout: 2))
    }
}
