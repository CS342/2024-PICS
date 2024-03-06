//
// This source file is part of the PICS to test the health data dashboard.
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest


class HealthVisualizationTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding", "--mockTestData"]

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
        
        // Tap on charts to trigger lollipop functions to ensure no errors.
        // We use the offset from the chart title to find the position to click on the chart.
        let xOffset: CGFloat = 50
        let yOffset: CGFloat = 100
        let normalized = app.coordinate(withNormalizedOffset: .zero)
        var frame = app.staticTexts["Heart Rate"].frame
        normalized.withOffset(CGVector(dx: frame.minX + xOffset, dy: frame.minY + yOffset)).tap()
        frame = app.staticTexts["Oxygen Saturation (%)"].frame
        normalized.withOffset(CGVector(dx: frame.minX + xOffset, dy: frame.minY + yOffset)).tap()
        frame = app.staticTexts["Step Count"].frame
        normalized.withOffset(CGVector(dx: frame.minX + xOffset, dy: frame.minY + yOffset)).tap()

        // Check to verify that the lollipop pop up the correct texts.
        // We manually set the average to 50, max to 100, and min to 1 in mock test data.
        let expectedDetail = "Daily Average: 50.0, Maximum: 100, Minimum: 1"
        // We manually set the sum of step count per day to 100 in mock test data.
        let stepText = ", 100"
        let sumText = "Your summary for"
        // The counts recording matched texts.
        var detailCnt = 0
        var stepDetailCnt = 0
        var summaryCnt = 0
        for staticText in app.staticTexts.allElementsBoundByIndex {
            let curLabel = staticText.label
            detailCnt += curLabel.contains(expectedDetail) ? 1 : 0
            summaryCnt += curLabel.contains(sumText) ? 1 : 0
            stepDetailCnt += curLabel.contains(stepText) ? 1 : 0
        }
        XCTAssertEqual(summaryCnt, 2)
        XCTAssertEqual(stepDetailCnt, 1)
        XCTAssertEqual(detailCnt, 2)
        
        // Tap again to deselect to verify no error happened.
        frame = app.staticTexts["Step Count"].frame
        normalized.withOffset(CGVector(dx: frame.minX + xOffset, dy: frame.minY + yOffset)).tap()
        frame = app.staticTexts["Heart Rate"].frame
        normalized.withOffset(CGVector(dx: frame.minX + xOffset, dy: frame.minY + yOffset)).tap()
        frame = app.staticTexts["Oxygen Saturation (%)"].frame
        normalized.withOffset(CGVector(dx: frame.minX + xOffset, dy: frame.minY + yOffset)).tap()
    }
}
