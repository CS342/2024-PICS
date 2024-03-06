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

    func testAssessmentViewPresence() {
        let app = XCUIApplication()

        // Example: Check for a static text that's always present in the Assessments view
        let assessmentTitle = app.staticTexts["ASSESSMENTS_NAVIGATION_TITLE"]
        XCTAssertTrue(assessmentTitle.waitForExistence(timeout: 5), "Assessments view should be present")
    }
}
