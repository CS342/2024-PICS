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
        XCTAssertNotEqual(scheduler.tasks.count, 0)
        print("Scheduler has \(scheduler.tasks.count) tasks:")
        scheduler.tasks.forEach { task in
            print("Task title: \(task.title)")
        }
        XCTAssertTrue(scheduler.tasks.contains(where: { $0.title == "PHQ-4: Patient Psychological Health Questionnaire" }))
    }
}
