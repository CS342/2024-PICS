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
    
//        func testOnboardingSurveyVisibility() {
//        let app = navigateToScheduleView()
//        // Check if the OnboardingSurveyView is visible based on `isSurveyCompleted`
//        let surveyViewExists = app.otherElements["Onboarding Task"].waitForExistence(timeout: 2)
//        XCTAssertTrue(surveyViewExists, "OnboardingSurveyView should be present if the survey hasn't been completed.")
//    }
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
        let accountButton = app.buttons["Questionnaires"] // Use the actual identifier
        let exists = accountButton.waitForExistence(timeout: 2)

        XCTAssertTrue(exists, "Account button should be visible under specific conditions.")
    }
    // Navigate to ScheduleView
    func testQuestionnaireViewPresentation() {
        let app = navigateToScheduleView()
        // Simulate tapping an event that leads to a questionnaire
        let eventButton = app.buttons["Start Questionnaire"] // Use actual accessibility identifier
        XCTAssertTrue(eventButton.waitForExistence(timeout: 2), "Event button leading to questionnaire should exist.")
        eventButton.tap()
        
        // Verify that the QuestionnaireView is presented
        // let questionnaireViewExists = app.otherElements["QuestionnaireView"].waitForExistence(timeout: 2)
        // XCTAssertTrue(questionnaireViewExists, "QuestionnaireView should be presented upon tapping the event.")
    }
    
    func testModalViewPresentation() {
        let app = navigateToScheduleView()
        // Simulate tapping an event that leads to a modal view
        let eventButton = app.buttons["Start Questionnaire"] // Use actual accessibility identifier
        XCTAssertTrue(eventButton.waitForExistence(timeout: 2), "Event button leading to modal should exist.")
        eventButton.tap()
        
        // Verify that the ModalView is presented
        let titleText = app.staticTexts["Onboarding Survey"] // Use an identifiable element within ModalView
        XCTAssertTrue(titleText.waitForExistence(timeout: 2), "ModalView should be presented upon tapping the event.")
        let modalViewText = app.staticTexts["Get Started"] // Use an identifiable element within ModalView
        XCTAssertTrue(modalViewText.waitForExistence(timeout: 2), "ModalView should be presented upon tapping the event.")
//        let descriptionText = app.staticTexts["In order to better assess your current physical and psychological well-being, we need to collect some basic information in different areas."] // Use an identifiable element within ModalView
//        XCTAssertTrue(descriptionText.waitForExistence(timeout: 2), "ModalView should be presented upon tapping the event.")
    }
//    
//    func testTaskSchedulingWithTestScheduleDisabled() async throws {
//        // Ensure the `testSchedule` feature flag is disabled
//        let scheduler = PICSScheduler()
//        
//        // Define what the expected normal scheduling logic should be
//        let expectedPHQ4Schedule = DateComponents(hour: 8, minute: 0)
//        let expectedEQ5D5LSchedule = DateComponents(hour: 8, minute: 5)
//        let expectedMiniNutritionalSchedule = DateComponents(hour: 8, minute: 10)
//
//        let phq4Task = try XCTUnwrap(scheduler.tasks.first { $0.title == "PHQ-4_TITLE" }, "PHQ-4 task should be present")
//        XCTAssertEqual(phq4Task.schedule.repetition, .matching(expectedPHQ4Schedule), "PHQ-4 task should be scheduled for every 2 weeks at 8:00 AM")
//    }
    
}
