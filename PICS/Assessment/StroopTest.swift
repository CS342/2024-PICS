//
//  SwiftUIView.swift
//  PICS
//
//  Created by Karan Soin on 2/29/24.
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
            ORKOrderedTaskView(
                tasks: createStroopTask(),
                tintColor: .accentColor,
                shouldConfirmCancel: true,
                result: handleTaskResult
            )
            .navigationBarTitle("STROOP_TEST_TITLE")
        }
    }

    private func createStroopTask() -> ORKOrderedTask {
        let task = ORKOrderedTask.stroopTask(
            withIdentifier: "StroopTask",
            intendedUseDescription: "Tests selective attention capacity and processing speed",
            numberOfAttempts: 5,
            options: []
        )
        return task
    }

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
                        let totalTime = curResult.endTime - curResult.startTime
                        let parsedResult = AssessmentResult(
                            testDateTime: Date(),
                            timeSpent: totalTime
                        )
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
