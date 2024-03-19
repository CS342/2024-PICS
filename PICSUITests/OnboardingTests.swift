//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTestExtensions
import XCTHealthKit


class OnboardingTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()

        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--showOnboarding"]
        app.deleteAndLaunch(withSpringboardAppName: "PICS")
    }
    
    // This test function go through the onboarding flow, and then check whether
    // the onboarding is completed and delete the account.
    func testOnboardingFlow() throws {
        let app = XCUIApplication()
        let email = "pics@onboarding.stanford.edu"
        
        try app.navigateOnboardingFlow(email: email)
        
        app.assertOnboardingComplete()
        try app.assertAccountInformation(email: email)
    }
    
    // This test run through the onboarding flow and then restart the app
    // to ensure that no healthkit and notification permission are asked.
    func testOnboardingFlowRepeated() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--showOnboarding", "--disableFirebase"]
        app.terminate()
        app.launch()
        
        try app.navigateOnboardingFlow(skipQuestionnaire: true)
        app.assertOnboardingComplete()
        
        app.terminate()
        // Second onboarding round shouldn't display HealthKit and Notification authorizations anymore.
        app.activate()

        try app.navigateOnboardingFlow(repeated: true, skipQuestionnaire: true)
        // Do not show HealthKit and Notification authorization view again.
        app.assertOnboardingComplete()
    }
    
    // This function go through the onboarding process
    func testOnboardingSkipQuestionnaire() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--showOnboarding", "--disableFirebase"]
        app.terminate()
        app.launch()
        
        try app.navigateOnboardingFlow(skipQuestionnaire: true)
        app.assertOnboardingComplete()
        
        try app.assertShowOnboardingQuestionnaire()
    }
}

extension XCUIApplication {
    fileprivate func navigateOnboardingFlow(
            email: String = "pics@stanford.edu",
            repeated skippedIfRepeated: Bool = false,
            skipQuestionnaire: Bool = false
    ) throws {
        try navigateOnboardingFlowWelcome()
        try navigateOnboardingFlowInterestingModules()
        // Create account.
        if staticTexts["Your Account"].waitForExistence(timeout: 5) {
            try navigateOnboardingAccount(email: email)
        }
        // Upload medication plan image.
        try navigateOnboardingMedication()

        // Fill out account questionnaire.
        if skipQuestionnaire {
            XCTAssertTrue(staticTexts["Onboarding Questionnaire"].waitForExistence(timeout: 2))
            XCTAssertTrue(buttons["Skip"].waitForExistence(timeout: 2))
            XCTAssertTrue(buttons["Take Questionnaire"].waitForExistence(timeout: 2))
            XCTAssertTrue(buttons["Skip"].waitForExistence(timeout: 2))
            buttons["Skip"].tap()
        } else {
            try navigateOnboardingQuestionnaire()
        }
        
        // Sign consent page.
        if staticTexts["Consent"].waitForExistence(timeout: 5) {
            try navigateOnboardingFlowConsent()
        }
        
        // We should only see healthkit and notification screens when we run onboarding for the
        // first time after installing the app.
        if !skippedIfRepeated {
            try navigateOnboardingFlowHealthKitAccess()
            try navigateOnboardingFlowNotification()
        }
        
        // Appointment Info, just keep the default.
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
        buttons["Next"].tap()
    }
    
    // Check the title in the welcome page and continue to next.
    private func navigateOnboardingFlowWelcome() throws {
        XCTAssertTrue(staticTexts["Post Intensive Care Syndrome App"].waitForExistence(timeout: 5))
        
        XCTAssertTrue(buttons["Learn More"].waitForExistence(timeout: 2))
        buttons["Learn More"].tap()
    }
    
    // Fill out the consent form.
    private func navigateOnboardingFlowConsent() throws {
        XCTAssertTrue(staticTexts["Consent"].waitForExistence(timeout: 5))
        
        XCTAssertTrue(staticTexts["First Name"].waitForExistence(timeout: 2))
        try textFields["Enter your first name ..."].enter(value: "Leland")
        
        XCTAssertTrue(staticTexts["Last Name"].waitForExistence(timeout: 2))
        try textFields["Enter your last name ..."].enter(value: "Stanford")

        XCTAssertTrue(scrollViews["Signature Field"].waitForExistence(timeout: 2))
        scrollViews["Signature Field"].swipeRight()

        XCTAssertTrue(buttons["I Consent"].waitForExistence(timeout: 2))
        buttons["I Consent"].tap()
    }
    
    // Signup for an account and fill in necessary information.
    private func navigateOnboardingAccount(email: String) throws {
        guard !buttons["Next"].waitForExistence(timeout: 5) else {
            buttons["Next"].tap()
            return
        }
        
        XCTAssertTrue(buttons["Signup"].waitForExistence(timeout: 2))
        buttons["Signup"].tap()

        XCTAssertTrue(staticTexts["Create a new Account"].waitForExistence(timeout: 2))

        try collectionViews.textFields["E-Mail Address"].enter(value: email)
        try collectionViews.secureTextFields["Password"].enter(value: "StanfordRocks")
        try textFields["enter first name"].enter(value: "Leland")
        try textFields["enter last name"].enter(value: "Stanford")
        
        swipeUp()
        
        XCTAssertTrue(collectionViews.buttons["Signup"].waitForExistence(timeout: 2))
        collectionViews.buttons["Signup"].tap()

        sleep(3)
        
        if staticTexts["HealthKit Access"].waitForExistence(timeout: 5) && navigationBars.buttons["Back"].waitForExistence(timeout: 5) {
            navigationBars.buttons["Back"].tap()
            
            XCTAssertTrue(staticTexts["Leland Stanford"].waitForExistence(timeout: 2))
            XCTAssertTrue(staticTexts[email].waitForExistence(timeout: 2))
            
            XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
            buttons["Next"].tap()
        }
    }
    
    // Click button to upload the image, choose iamge to upload, and then go to the next page.
    private func navigateOnboardingMedication() throws {
        XCTAssertTrue(staticTexts["Medication Information"].waitForExistence(timeout: 2))
        
        XCTAssertTrue(buttons["Add"].waitForExistence(timeout: 2))
        buttons["Add"].tap()
        XCTAssertTrue(buttons["Photo Picker"].waitForExistence(timeout: 2))
        buttons["Photo Picker"].tap()
        
        // Wait a few seconds for images to appear.
        sleep(2)
        // Find the image to choose. It is not hittable so we retrive its coordinate to tap.
        let img = images.element(boundBy: 0).frame
        let normalized = coordinate(withNormalizedOffset: .zero)
        normalized.withOffset(CGVector(dx: img.midX, dy: img.midY)).tap()
        
        // Upload the selected photo.
        XCTAssertTrue(buttons["Upload Photo"].waitForExistence(timeout: 5))
        buttons["Upload Photo"].tap()
    }
    
    // Go throught the account questionnaire here.
    private func navigateOnboardingQuestionnaire() throws {
        XCTAssertTrue(buttons["Take Questionnaire"].waitForExistence(timeout: 2))
        buttons["Take Questionnaire"].tap()
        XCTAssertTrue(buttons["Get Started"].waitForExistence(timeout: 2))
        buttons["Get Started"].tap()
        
        XCTAssertTrue(staticTexts["Female"].waitForExistence(timeout: 2))
        staticTexts["Female"].tap()
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
        buttons["Next"].tap()
        
        // Age key.
        sleep(1)
        try textFields["Tap to answer"].enter(value: "1")
        XCTAssertTrue(buttons["Done"].waitForExistence(timeout: 2))
        buttons["Done"].tap()
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
        buttons["Next"].tap()
        
        // Height key.
        sleep(1)
        try textFields["Tap to answer"].enter(value: "1")
        XCTAssertTrue(buttons["Done"].waitForExistence(timeout: 2))
        buttons["Done"].tap()
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
        buttons["Next"].tap()
        
        // Weight key.
        sleep(1)
        try textFields["Tap to answer"].enter(value: "1")
        XCTAssertTrue(buttons["Done"].waitForExistence(timeout: 2))
        buttons["Done"].tap()
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
        buttons["Next"].tap()
        
        // Need for care and degree of disability, use the default value.
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
        buttons["Next"].tap()
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
        buttons["Next"].tap()
        
        XCTAssertTrue(staticTexts["Yes"].waitForExistence(timeout: 2))
        staticTexts["Yes"].tap()
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
        buttons["Next"].tap()
        
        XCTAssertTrue(staticTexts["Single"].waitForExistence(timeout: 2))
        staticTexts["Single"].tap()
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
        buttons["Next"].tap()
        
        XCTAssertTrue(staticTexts["Living alone"].waitForExistence(timeout: 2))
        staticTexts["Living alone"].tap()
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
        buttons["Next"].tap()
        
        XCTAssertTrue(staticTexts["College degree"].waitForExistence(timeout: 2))
        staticTexts["College degree"].tap()
        XCTAssertTrue(buttons["Done"].waitForExistence(timeout: 2))
        buttons["Done"].tap()
    }
    
    // This function click through the interesting modules page and go to the next.
    private func navigateOnboardingFlowInterestingModules() throws {
        XCTAssertTrue(staticTexts["How PICS works"].waitForExistence(timeout: 5))
        
        for _ in 1..<4 {
            XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
            buttons["Next"].tap()
        }
        
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
        buttons["Next"].tap()
    }
    
    // This function retrieve the healthkit access and go to the next.
    private func navigateOnboardingFlowHealthKitAccess() throws {
        XCTAssertTrue(staticTexts["PICS HealthKit Access"].waitForExistence(timeout: 5))
        XCTAssertTrue(buttons["Grant Access"].waitForExistence(timeout: 2))
        buttons["Grant Access"].tap()
        
        try handleHealthKitAuthorization()
    }
    
    // This function retrieve the notification permission and go to the next.
    private func navigateOnboardingFlowNotification() throws {
        XCTAssertTrue(staticTexts["Notifications"].waitForExistence(timeout: 5))
        
        XCTAssertTrue(buttons["Allow Notifications"].waitForExistence(timeout: 2))
        buttons["Allow Notifications"].tap()
        
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let alertAllowButton = springboard.buttons["Allow"]
        if alertAllowButton.waitForExistence(timeout: 5) {
           alertAllowButton.tap()
        }
    }
    
    // This function checks whether the tab buttons occurs in our app to check
    // whether we finish the whole onboarding flow.
    fileprivate func assertOnboardingComplete() {
        XCTAssertTrue(buttons["Appointments"].waitForExistence(timeout: 2))
        XCTAssertTrue(buttons["Questionnaires"].waitForExistence(timeout: 2))
        XCTAssertTrue(buttons["Assessments"].waitForExistence(timeout: 2))
        XCTAssertTrue(buttons["Health"].waitForExistence(timeout: 2))
     }

    // This function verify the account page information and then delete the account
    // in case of duplicate account error.
    fileprivate func assertAccountInformation(email: String) throws {
        // Check whether the information are loaded correctly.
        XCTAssertTrue(navigationBars.buttons["Your Account"].waitForExistence(timeout: 2))
        navigationBars.buttons["Your Account"].tap()
        XCTAssertTrue(staticTexts["Account Overview"].waitForExistence(timeout: 5.0))
        XCTAssertTrue(staticTexts["Leland Stanford"].exists)
        XCTAssertTrue(staticTexts[email].exists)
        // Check for licencing.
        XCTAssertTrue(buttons["License Information"].waitForExistence(timeout: 2))
        buttons["License Information"].tap()
        // Test if the sheet opens by checking if the info of the licence is present
        XCTAssertTrue(staticTexts["This project is licensed under the MIT License."].waitForExistence(timeout: 2))
        print(debugDescription)
        XCTAssertTrue(buttons["Repository Link"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(buttons["Account Overview"].waitForExistence(timeout: 0.5))
        buttons["Account Overview"].tap()
        
        XCTAssertTrue(navigationBars.buttons["Close"].waitForExistence(timeout: 0.5))
        navigationBars.buttons["Close"].tap()

        // Show the edit page to ensure no errors occur.
        XCTAssertTrue(navigationBars.buttons["Your Account"].waitForExistence(timeout: 2))
        navigationBars.buttons["Your Account"].tap()
        XCTAssertTrue(navigationBars.buttons["Edit"].waitForExistence(timeout: 2))
        navigationBars.buttons["Edit"].tap()
        usleep(500_00)
        XCTAssertFalse(navigationBars.buttons["Close"].exists)
        
        // Delete the account.
        XCTAssertTrue(buttons["Delete Account"].waitForExistence(timeout: 2))
        buttons["Delete Account"].tap()

        let alert = "Are you sure you want to delete your account?"
        XCTAssertTrue(alerts[alert].waitForExistence(timeout: 6.0))
        alerts[alert].buttons["Delete"].tap()

        XCTAssertTrue(alerts["Authentication Required"].waitForExistence(timeout: 2.0))
        XCTAssertTrue(alerts["Authentication Required"].secureTextFields["Password"].waitForExistence(timeout: 0.5))
        typeText("StanfordRocks") // the password field has focus already
        XCTAssertTrue(alerts["Authentication Required"].buttons["Login"].waitForExistence(timeout: 0.5))
        alerts["Authentication Required"].buttons["Login"].tap()

        sleep(2)

        // Login again with non-existing account, should receive error.
        try textFields["E-Mail Address"].enter(value: email)
        try secureTextFields["Password"].enter(value: "StanfordRocks")

        XCTAssertTrue(buttons["Login"].waitForExistence(timeout: 0.5))
        buttons["Login"].tap()

        XCTAssertTrue(alerts["Invalid Credentials"].waitForExistence(timeout: 2.0))
    }
    
    // This function check whether the onboarding questionnaire appear in the
    // questionnaires tab.
    fileprivate func assertShowOnboardingQuestionnaire() throws {
        XCTAssertTrue(buttons["Questionnaires"].waitForExistence(timeout: 2))
        buttons["Questionnaires"].tap()
        
        XCTAssertTrue(staticTexts["PERSONAL INFORMATION"].waitForExistence(timeout: 2))
        XCTAssertTrue(staticTexts["Onboarding Questionnaire"].waitForExistence(timeout: 2))
    }
 }
