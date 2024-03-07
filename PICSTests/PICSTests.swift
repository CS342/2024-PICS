//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

@testable import PICS
import XCTest


class PICSTests: XCTestCase {
    func testExample() throws {
        XCTAssertTrue(true)
    }
    
    // Testing the PICSScheduler initialization
    func testInitializationWithDefaultTasks() {
        let scheduler = PICSScheduler()
        XCTAssertEqual(scheduler.tasks.count, 3)
        XCTAssertTrue(scheduler.tasks.contains(where: { $0.title == "PHQ-4_TITLE" }))
        XCTAssertTrue(scheduler.tasks.contains(where: { $0.title == "EQ5D5L_TITLE" }))
        XCTAssertTrue(scheduler.tasks.contains(where: { $0.title == "MiniNutritional_TITLE" }))
    }
    // Testing the PICSTaskContext enum
    func testQuestionnairePICSTaskContext() {
        let questionnaire = Bundle.main.questionnaire(withName: "PHQ-4")
        let context = PICSTaskContext.questionnaire(questionnaire)
        XCTAssertEqual(context.actionType, LocalizedStringResource("TASK_CONTEXT_ACTION_QUESTIONNAIRE"))
        XCTAssertNotNil(context.id)
    }
    
    func testTestPICSTaskContext() {
        let context = PICSTaskContext.test("Test string")
        XCTAssertEqual(context.actionType, LocalizedStringResource("TASK_CONTEXT_ACTION_TEST"))
        XCTAssertNotNil(context.id)
    }
}
