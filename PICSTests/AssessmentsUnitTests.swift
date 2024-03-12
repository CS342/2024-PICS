//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

@testable import PICS
import ResearchKit
import XCTest


class AssessmentsUnitTests: XCTestCase {
    // Test tha the trail making test result could be parsed correctly without error.
    func testParseTMResult() throws {
        // Create the task result object with trail making results.
        let taskResult = ORKTaskResult(taskIdentifier: "TestTMTaskResult", taskRun: UUID(), outputDirectory: nil)
        
        let tmResult = ORKTrailmakingResult(identifier: "tmResult")
        tmResult.numberOfErrors = 10
        let tmTap1 = ORKTrailmakingTap()
        tmTap1.timestamp = 20
        let tmTap2 = ORKTrailmakingTap()
        tmTap2.timestamp = 30
        tmResult.taps = [tmTap1, tmTap2]
        
        let tmStepResult = ORKStepResult(stepIdentifier: "trailmaking", results: [tmResult])
        taskResult.results = [tmStepResult]
        
        if let parsedResult = parseTMResult(taskResult: taskResult) {
            // The correct timestamp is the one from the last tap.
            XCTAssertEqual(parsedResult.timeSpent, 30)
            XCTAssertEqual(parsedResult.errorCnt, 10)
        } else {
            // Failed to parse the result.
            XCTAssert(true)
        }
    }
}
