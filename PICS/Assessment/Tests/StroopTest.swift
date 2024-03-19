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
    @Environment(AssessmentResults.self)
    private var results

    @Environment(\.dismiss)
    var dismiss

    private var stroopTask: ORKOrderedTask {
        .stroopTask(
            withIdentifier: "StroopTask",
            intendedUseDescription: "Tests selective attention capacity and processing speed",
            numberOfAttempts: 5,
            options: [.excludeAudio]
        )
    }

    var body: some View {
        ORKOrderedTaskView(
            tasks: stroopTask,
            result: handleTaskResult
        )
    }

    private func handleTaskResult(result: TaskResult) {
        dismiss()
        
        guard case let .completed(taskResult) = result else {
            return
        }

        guard let taskResults = taskResult.results else {
            return
        }

        // Fields to record the aggregated test results.
        var totalTime: TimeInterval = 0
        var errorCnt = 0
        
        // Extract and process the Stroop test results.
        for result in taskResults {
            guard let stepResult = result as? ORKStepResult,
                  stepResult.identifier == "stroop" else {
                continue
            }

            for stepResult in stepResult.results ?? [] {
                guard let stroppResult = stepResult as? ORKStroopResult else {
                    continue
                }

                // Calculates the total time taken to complete the test.
                totalTime += stroppResult.endTime - stroppResult.startTime
                if stroppResult.color != stroppResult.colorSelected {
                    errorCnt += 1
                }
            }
        }

        // Record the result to the app storage of Stroop test results.
        let parsedResult = AssessmentResult(
            testDateTime: Date(),
            timeSpent: totalTime,
            errorCnt: errorCnt
        )
        
        results.stroopTestResults.append(parsedResult)
    }
}


#if DEBUG
#Preview {
    StroopTestView()
        .environment(AssessmentResults())
}
#endif
