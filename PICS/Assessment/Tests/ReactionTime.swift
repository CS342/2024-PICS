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

struct ReactionTimeView: View {
    @Environment(AssessmentResults.self)
    private var results

    @Environment(\.dismiss)
    var dismiss


    private var reactionTimeTask: ORKOrderedTask {
        .reactionTime(
            withIdentifier: "ReactionTimeTask",
            intendedUseDescription: nil,
            maximumStimulusInterval: 2.0,
            minimumStimulusInterval: 1.0,
            thresholdAcceleration: 0.8,
            numberOfAttempts: 5,
            timeout: 5.0,
            successSound: 0,
            timeoutSound: 0,
            failureSound: 0,
            options: [.excludeConclusion]
        )
    }

    var body: some View {
        ORKOrderedTaskView(
            tasks: reactionTimeTask,
            result: handleTaskResult
        )
    }


    // Handles the result of the ReactionTime task.
    private func handleTaskResult(result: TaskResult) {
        dismiss()

        guard case let .completed(taskResult) = result else {
            return // Failed or canceled test. Do nothing for current.
        }

        guard let taskResults = taskResult.results else {
            return
        }

        // Fields to record the aggregated test results.
        var totalTime: TimeInterval = 0
        var steps = 0

        // Extract and process the ReactionTime test results.
        for result in taskResults {
            guard let stepResult = result as? ORKStepResult,
                  stepResult.identifier == "reactionTime",
                  let stepResults = stepResult.results else {
                continue
            }

            for stepResult in stepResults {
                guard let reactionTimeResult = stepResult as? ORKReactionTimeResult else {
                    continue
                }
#if targetEnvironment(simulator)
                // adding fixed size because ReactionTime does not work on simulator
                totalTime += 0.5
                steps += 1
#else
                // get DeviceMotion data to find elapsed time
                guard let jsonURL = reactionTimeResult.fileResult.fileURL else {
                    continue
                }

                do {
                    let jsonData = try Data(contentsOf: jsonURL)
                    let decoder = JSONDecoder()

                    let deviceMotion = try decoder.decode(DeviceMotion.self, from: jsonData)
                    if let lastItem = deviceMotion.items.last {
                        totalTime += (lastItem.timestamp - reactionTimeResult.timestamp)
                        steps += 1
                    }
                } catch {
                    print("Error parsing JSON:", error)
                }
#endif
            }
        }

        guard steps > 0 else {
            return
        }

        let result = AssessmentResult(testDateTime: Date(), timeSpent: totalTime / Double(steps))
        results.reactionTimeResults.append(result)
    }
}


#if DEBUG
#Preview {
    ReactionTimeView()
        .environment(AssessmentResults())
}
#endif
