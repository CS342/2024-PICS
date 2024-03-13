//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

@testable import PICS
import XCTest
import XCTSpezi


class PICSTests: XCTestCase {
    func testExample() throws {
        XCTAssertTrue(true)
    }
    // Testing the PICSScheduler initialization
    func testInitializationWithDefaultTasks() async throws {
        let scheduler = PICSScheduler()
        withDependencyResolution {
            scheduler
        }
        try await Task.sleep(for: .milliseconds(500))
        XCTAssertEqual(scheduler.tasks.count, 3)
        print("Scheduler has \(scheduler.tasks.count) tasks:")
        scheduler.tasks.forEach { task in
            print("Task title: \(task.title)")
        }
        XCTAssertTrue(scheduler.tasks.contains(where: { $0.title == "PHQ-4: Patient Psychological Health Questionnaire" }))
        XCTAssertTrue(scheduler.tasks.contains(where: { $0.title == "EQ-5D-5L: Patient Physical Health Questionnaire" }))
        XCTAssertTrue(scheduler.tasks.contains(where: { $0.title == "Self-MNA: Mini Nutritional Assessment" }))
    }
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        continueAfterFailure = false
//        
//        let app = XCUIApplication()
//        
//        app.launchArguments = ["--skipOnboarding", "--mockTestData", "--disableFirebase", "--testSchedule"]
//        app.launch()
//    }
//    
//    func testTaskSchedulingWithTestScheduleDisabled() async throws {
//
//        let scheduler = PICSScheduler()
//        withDependencyResolution {
//            scheduler
//        }
//        
//        // Define what the expected normal scheduling logic should be
//        let expectedPHQ4Schedule = DateComponents(hour: 8, minute: 0)
//        let expectedEQ5D5LSchedule = DateComponents(hour: 8, minute: 5)
//        let expectedMiniNutritionalSchedule = DateComponents(hour: 8, minute: 10)
//
//        let phq4Task = try XCTUnwrap(scheduler.tasks.first { $0.title == "PHQ-4: Patient Psychological Health Questionnaire" }, "PHQ-4 task should be present")
////        XCTAssertEqual(phq4Task.schedule.repetition, .matching(expectedPHQ4Schedule), "PHQ-4 task should be scheduled for every 2 weeks at 8:00 AM")
//
//        // Similar checks for EQ5D5LTask and MiniNutritionalTask
//    }
}
