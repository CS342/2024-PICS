//
// This source file is part of the PICS to test the assessments task tab.
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest

class AssessmentsTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding", "--mockTestData", "--disableFirebase"]
        app.launch()
    }
    
    // This function launch the app and go to the assessment tab. Error will
    // be thrown if no "Assessments" button found.
    func getAssessmentTab() -> XCUIElement {
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding", "--mockTestData", "--disableFirebase"]
        
        // Go to the assessment dashboard.
        XCTAssertTrue(app.buttons["Assessments"].waitForExistence(timeout: 2))
        app.buttons["Assessments"].tap()
        return app
    }
    
    func testAssessmentTextsPresence() {
        let app = getAssessmentTab()
        XCTAssertTrue(app.staticTexts["Trail Making Test Results"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Stroop Test Results"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Reaction Time Results"].waitForExistence(timeout: 2))
    }
    
    // Click in each assessments to check taht we are able to successfully create and start each assessment.
    // Currently, we simply cancel the task for trail making and reaction time tasks as the testing of the
    // task process should also be handled through ResearchKit and it's hard to test both tests as described
    // below in skipTest function.
    func testRunAssessments() {
        let app = getAssessmentTab()
        let btnsIdf = ["startTrailMakingTestButton", "startStroopTestButton", "startReactimeTestButton"]
        let asmFuncs: [( (XCUIElement) -> Void )] = [skipTest, runStroopTest, skipTest]
        for (idf, asmFunc) in zip(btnsIdf, asmFuncs) {
            // Start assessment tasks by clicking respective buttons.
            XCTAssertTrue(app.buttons[idf].waitForExistence(timeout: 2))
            app.buttons[idf].tap()
            
            // Check texts in this view.
            while app.buttons["Next"].waitForExistence(timeout: 2) {
                app.buttons["Next"].tap()
            }
            XCTAssertTrue(app.buttons["Get Started"].waitForExistence(timeout: 2))
            app.buttons["Get Started"].tap()
            
            // Run or cancel the assessments.
            asmFunc(app)
        }
    }
    
    // Cancel the task to go back to original page. This is used for (1) trail making task
    // for which we are unable to click the buttons to make trails as they are not showned
    // in the app but grouped into an Other element 'Tappable Buttons', and (2) reaction
    // time task as currently there is no supports for the shake motion in testing.
    func skipTest(app: XCUIElement) {
        XCTAssertTrue(app.buttons["Cancel"].waitForExistence(timeout: 2))
        app.buttons["Cancel"].tap()
        XCTAssertTrue(app.buttons["End Task"].waitForExistence(timeout: 2))
        app.buttons["End Task"].tap()
    }
    
    // Check content and run through the Stroop Assessment.
    func runStroopTest(app: XCUIElement) {
        // The test will start in 5 secondes, adding a buffer, we wait for 7 seconds.
        sleep(7)
        
        // Click on "R" for all attempts.
        for _ in 0...4 {
            XCTAssertTrue(app.staticTexts["R"].waitForExistence(timeout: 2))
            app.staticTexts["R"].tap()
        }
        
        XCTAssertTrue(app.buttons["Done"].waitForExistence(timeout: 2))
        app.buttons["Done"].tap()
    }
    
    // Test whether the charts pop up the correct details for the assessment results when
    // clicking/not clicking on the charts.
    func testResultViz() {
        let app = getAssessmentTab()
        
        // We use the offset from the chart title to find the position to click on the chart.
        let xOffset: CGFloat = 50
        let yOffset: CGFloat = 150
        let normalized = app.coordinate(withNormalizedOffset: .zero)
        let frame = app.staticTexts["Trail Making Test Results"].frame
        normalized.withOffset(CGVector(dx: frame.minX + xOffset, dy: frame.minY + yOffset)).tap()
        checkOccurrenceResultTexts(app: app)
        
        // Click again to reset the details, ensure that no error happened.
        normalized.withOffset(CGVector(dx: frame.minX + xOffset, dy: frame.minY + yOffset)).tap()
        checkOccurrenceResultTexts(app: app, hideDetails: true)
    }
    
    // Check the text occurrences for results to ensure that we show correct details.
    func checkOccurrenceResultTexts(app: XCUIElement, hideDetails: Bool = false) {
        // Check to verify that the details pop up the correct texts.
        // The unclicked results details should show the last result.
        let lastResultText = "Your last assessment result at"
        // The clicked result should show with different prefix texts.
        let clickedResultText = "Your assessment result at"
        // We manually set the time spent to 10 for all three tasks.
        let timeText = "Time Spent (seconds): 10.0"
        var lastResultCnt = 0
        var timeTextCnt = 0
        var clickedResultCnt = 0
        for staticText in app.staticTexts.allElementsBoundByIndex {
            let curLabel = staticText.label
            lastResultCnt += curLabel.contains(lastResultText) ? 1 : 0
            clickedResultCnt += curLabel.contains(clickedResultText) ? 1 : 0
            timeTextCnt += curLabel.contains(timeText) ? 1 : 0
        }
        XCTAssertEqual(lastResultCnt, hideDetails ? 3 : 2)
        XCTAssertEqual(timeTextCnt, 3)
        XCTAssertEqual(clickedResultCnt, hideDetails ? 0 : 1)
    }
}
