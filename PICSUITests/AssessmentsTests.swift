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
    }
    
    // Click in each assessments to check taht we are able to successfully run the assessments.
    // Currently, we simply cancel the task as the actual tas
    func testRunAssessments() {
        let app = getAssessmentTab()
        let btnsIdf = ["startTrailMakingTestButton", "startStroopTestButton", "startReactimeTestButton"]
        let asmFuncs: [( (XCUIElement) -> Void )] = [skipTest, runStroopTest, skipTest]
        for (idf, asmFunc) in zip(btnsIdf, asmFuncs) {
            XCTAssertTrue(app.buttons[idf].waitForExistence(timeout: 2))
            app.buttons[idf].tap()
            
            // Check texts in this view.
            while app.buttons["Next"].waitForExistence(timeout: 2) {
                app.buttons["Next"].tap()
            }
            XCTAssertTrue(app.buttons["Get Started"].waitForExistence(timeout: 2))
            app.buttons["Get Started"].tap()
            
            // Run the assessments.
            asmFunc(app)
        }
    }
    
    // Cancel the task to go back to original page. This is used for (1) trail making task
    // for which we are unable to click the buttons to make trails as they are not showned
    // in the app but grouped into an Other element 'Tappable Buttons', and (2) reaction
    // time task as currently there is no supports for the shake motion in testing. Instead,
    // we write unit tests for functions parsing the two task results as the task process
    // should be also tested in ResearchKit package.
    func skipTest(app: XCUIElement) {
        XCTAssertTrue(app.buttons["Cancel"].waitForExistence(timeout: 2))
        app.buttons["Cancel"].tap()
        XCTAssertTrue(app.buttons["End Task"].waitForExistence(timeout: 2))
        app.buttons["End Task"].tap()
    }
    
    // Check content and run through the Trail Making Assessment.
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
}
