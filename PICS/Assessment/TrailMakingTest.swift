//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import ResearchKit
import ResearchKitSwiftUI
import SwiftUI

struct TrailMakingTaskView: View {
    // Use @AppStorage to store the selected dates
    @AppStorage("trailMakingResults") private var tmStorageResults: [AssessmentResult] = []

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(red: 242 / 255, green: 242 / 255, blue: 247 / 255)
                .edgesIgnoringSafeArea(.all)
            ORKOrderedTaskView(
                tasks: createTrailMakingTask(),
                tintColor: .accentColor,
                shouldConfirmCancel: true,
                result: handleTaskResult
            )
            .navigationBarTitle("TRAIL_MAKING_TEST_TITLE")
        }
    }
    
    private func createTrailMakingTask() -> ORKOrderedTask {
        let task = ORKOrderedTask.trailmakingTask(
            withIdentifier: "TrailMakingTask",
            intendedUseDescription: "Tests visual attention and task switching",
            trailmakingInstruction: nil,
            trailType: .B,
            options: []
        )
        return task
    }
    
    // Handle task result
    private func handleTaskResult(result: TaskResult) async {
        // Close the test by dismissing the view
        DispatchQueue.main.async {
            self.presentationMode.wrappedValue.dismiss()
        }
        
        let parsedResult = parseTMResult(result: result)
        if let nonEmptyResult = parsedResult{
            tmStorageResults += [nonEmptyResult]
        }
    }
    
    public func parseTMResult(result: TaskResult) -> AssessmentResult? {
        guard case let .completed(taskResult) = result else {
            return nil
        }
        // Go to the trail making results and parse the result.
        for result in taskResult.results ?? [] {
            if let stepResult = result as? ORKStepResult {
                if stepResult.identifier != "trailmaking" {
                    continue
                }
                for trailMakingResult in stepResult.results ?? [] {
                    if let curResult = trailMakingResult as? ORKTrailmakingResult {
                        let timeTask = if let lastItem = curResult.taps.last {
                            lastItem.timestamp
                        } else {
                            -1.0
                        }
                        let parsedResult = AssessmentResult(
                            testDateTime: Date(),
                            timeSpent: timeTask,
                            errorCnt: Int(curResult.numberOfErrors)
                        )
                        return parsedResult
                    }
                }
            }
        }
        return nil
    }
}

#Preview {
    TrailMakingTaskView()
}
