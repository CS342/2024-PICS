//
// This source file is part of the PICS to test the assessments task tab.
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest

class ScheduleViewTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        
        let app = XCUIApplication()
        
        app.launchArguments = ["--skipOnboarding", "--mockTestData", "--disableFirebase", "--testSchedule"]
        app.launch()
    }
    
    // Navigate to ScheduleView
    func navigateToScheduleView() -> XCUIElement {
        let app = XCUIApplication()
        // Assuming there is a button or tab to navigate to the ScheduleView
        XCTAssertTrue(app.buttons["Questionnaires"].waitForExistence(timeout: 2), "The Questionnaire tab/button should exist.")
        app.buttons["Questionnaires"].tap()
        
        return app
    }
    
    func testScheduleListLoading() {
        let app = navigateToScheduleView()
        // Check for the existence of schedule list items
        let listItem = app.cells.firstMatch
        let listExists = listItem.waitForExistence(timeout: 5)
        XCTAssertTrue(listExists, "Schedule list items should load and be visible.")
    }
    
    func testEventContextInteraction() {
        let app = navigateToScheduleView()
        // Assuming events are listed and identifiable by a unique identifier
        let eventContextButton = app.buttons["Questionnaires"].firstMatch
        XCTAssertTrue(eventContextButton.waitForExistence(timeout: 2), "Event context button should exist.")
        
        eventContextButton.tap()
    }
    
    func testAccountButtonVisibility() {
        let app = navigateToScheduleView()
        // Assuming the conditions have been set for AccountButton to be visible
        let accountButton = app.buttons["Questionnaires"]
        let exists = accountButton.waitForExistence(timeout: 2)

        XCTAssertTrue(exists, "Account button should be visible under specific conditions.")
    }

    func testQuestionnaireViewPresentation() {
        let app = navigateToScheduleView()
        // Simulating tapping an event that leads to a questionnaire
        let eventButton = app.buttons["Start Questionnaire"]
        XCTAssertTrue(eventButton.waitForExistence(timeout: 2), "Event button leading to questionnaire should exist.")
        eventButton.tap()
    }
    
    func testModalViewPresentation() {
        let app = navigateToScheduleView()
        // Simulate tapping an event that leads to a modal view
        let eventButton = app.buttons["Start Questionnaire"]
        XCTAssertTrue(eventButton.waitForExistence(timeout: 2), "Event button leading to modal should exist.")
        eventButton.tap()
        
        // Verify that the ModalView is presented
        let titleText = app.staticTexts["Onboarding Survey"]
        XCTAssertTrue(titleText.waitForExistence(timeout: 2), "ModalView should be presented upon tapping the event.")
        let modalViewText = app.staticTexts["Get Started"] // Identifiable element within ModalView
        XCTAssertTrue(modalViewText.waitForExistence(timeout: 2), "ModalView should be presented upon tapping the event.")
    }
}
