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
    @AppStorage("AssessmentsInProgress") private var assessmentsIP = false
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
            numberOfAttempts: 2,
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
        let curTime = ProcessInfo.processInfo.systemUptime
        assessmentsIP = false // End the assessment
        // Adding this logic to dismiss the view
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
                        // get DeviceMotion data
                        let jsonURL = curResult.fileResult.fileURL
                        if let jsonURL = jsonURL, let jsonData = try? Data(contentsOf: jsonURL) {
                            do {
                                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                                if let items = json?["items"] as? [[String: Any]],
                                   let lastItem = items.last,
                                   let lastTimestamp = lastItem["timestamp"] as? TimeInterval {
                                    let reactionTime = (curResult.timestamp - lastTimestamp) * 1000 // in milliseconds
                                    totalTime += reactionTime
                                }
                            } catch {
                                print("Error parsing JSON:", error)
                            }
                        }
                    }
                }
            }
        }
        reactionTimeResults += [AssessmentResult(testDateTime: Date(), timeSpent: totalTime)]
    }
}

#Preview {
    ReactionTimeView()
}
