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
    @AppStorage("reactionTimeResults") private var reactionTimeResults: [AssessmentResult] = []
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(red: 242 / 255, green: 242 / 255, blue: 247 / 255)
                .edgesIgnoringSafeArea(.all)
            // Displays the ResearchKit ordered task view for the ReactionTime Test.
            ORKOrderedTaskView(
                tasks: createReactionTimeTask(),
                tintColor: .accentColor,
                shouldConfirmCancel: true,
                result: handleTaskResult
            )
        }
    }

    // Creates the ReactionTime task to be presented to the user
    private func createReactionTimeTask() -> ORKOrderedTask {
        // Initializes a ReactionTime task with the following specified parameters
        let task = ORKOrderedTask.reactionTime(
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
        return task
    }
    // Handles the result of the ReactionTime task.
    private func handleTaskResult(result: TaskResult) async {
        // Close the test by dismissing the view
        DispatchQueue.main.async {
            self.presentationMode.wrappedValue.dismiss()
        }
        
        guard case let .completed(taskResult) = result else {
            // Failed or canceled test. Do nothing for current.
            return
        }
        // Fields to record the aggregated test results.
        var totalTime: TimeInterval = 0
        // Extract and process the ReactionTime test results.
        for result in taskResult.results ?? [] {
            if let stepResult = result as? ORKStepResult,
               stepResult.identifier == "reactionTime" {
                for reactionTimeResult in stepResult.results ?? [] {
                    if let curResult = reactionTimeResult as? ORKReactionTimeResult {
                        #if targetEnvironment(simulator)
                            // adding fixed size because ReactionTime does not work on simulator
                            totalTime += 0.5
                        #else
                            // get DeviceMotion data to find elapsed time
                            let jsonURL = curResult.fileResult.fileURL
                            if let jsonURL = jsonURL, let jsonData = try? Data(contentsOf: jsonURL) {
                                let decoder = JSONDecoder()
                                do {
                                    let deviceMotion = try decoder.decode(DeviceMotion.self, from: jsonData)
                                    if let lastItem = deviceMotion.items.last {
                                        totalTime += (lastItem.timestamp - curResult.timestamp)
                                    }
                                } catch {
                                    print("Error parsing JSON:", error)
                                }
                            }
                        #endif
                    }
                }
            }
        }
        reactionTimeResults += [AssessmentResult(testDateTime: Date(), timeSpent: totalTime / 5)]
    }
}

#Preview {
    ReactionTimeView()
}
