//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import ResearchKit
import ResearchKitSwiftUI
import SwiftUI

struct StroopTestView: View {
    @AppStorage("stroopTestResults") private var stroopTestResults: [AssessmentResult] = []
    @AppStorage("AssessmentsInProgress") private var assessmentsIP = false

    var body: some View {
        ZStack {
            Color(red: 242 / 255, green: 242 / 255, blue: 247 / 255)
                .edgesIgnoringSafeArea(.all)
            // Displays the ResearchKit ordered task view for the Stroop Test
            ORKOrderedTaskView(
                tasks: createStroopTask(),
                tintColor: .accentColor,
                shouldConfirmCancel: true,
                result: handleTaskResult
            )
            .navigationBarTitle("STROOP_TEST_TITLE")
        }
    }

    // Creates the Stroop task to be presented to the user
    private func createStroopTask() -> ORKOrderedTask {
        // Initializes a Stroop task with the following specified parameters
        let task = ORKOrderedTask.stroopTask(
            withIdentifier: "StroopTask",
            intendedUseDescription: "Tests selective attention capacity and processing speed",
            numberOfAttempts: 5,
            options: []
        )
        return task
    }

    // Handles the result of the Stroop task after completion
    private func handleTaskResult(result: TaskResult) async {
        assessmentsIP = false // End the assessment
        guard case let .completed(taskResult) = result else {
            // Handle incomplete or canceled test
            return
        }

        // Extract and process the Stroop test results
        for result in taskResult.results ?? [] {
            if let stepResult = result as? ORKStepResult,
               stepResult.identifier == "stroopTestIdentifier" {
                for stroopResult in stepResult.results ?? [] {
                    if let curResult = stroopResult as? ORKStroopResult {
                        // Calculates the total time taken to complete the test
                        let totalTime = curResult.endTime - curResult.startTime
                        let parsedResult = AssessmentResult(
                            testDateTime: Date(),
                            timeSpent: totalTime
                        )
                        // Adds the result to the array of Stroop test results
                        stroopTestResults += [parsedResult]
                    }
                }
            }
        }
    }
}

#Preview {
    StroopTestView()
}
