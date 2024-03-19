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
    @Environment(AssessmentResults.self)
    private var results

    @Environment(\.dismiss)
    var dismiss

    private var trailMakingTask: ORKOrderedTask {
        .trailmakingTask(
            withIdentifier: "TrailMakingTask",
            intendedUseDescription: "Tests visual attention and task switching",
            trailmakingInstruction: nil,
            trailType: .B,
            options: []
        )
    }

    var body: some View {
        ORKOrderedTaskView(
            tasks: trailMakingTask,
            tintColor: .accentColor,
            cancelBehavior: .shouldConfirmCancel,
            result: handleTaskResult
        )
    }

    private func handleTaskResult(result: TaskResult) {
        dismiss()

        guard case let .completed(taskResult) = result else {
            return
        }

        let parsedResult = parseTMResult(taskResult: taskResult)
        if let nonEmptyResult = parsedResult {
            results.tmStorageResults.append(nonEmptyResult)
        }
    }
}


func parseTMResult(taskResult: ORKTaskResult) -> AssessmentResult? {
    guard let taskResults = taskResult.results else {
        return nil
    }

    for result in taskResults {
        guard let stepResult = result as? ORKStepResult,
              stepResult.identifier == "trailmaking" else {
            continue
        }

        for stepResult in stepResult.results ?? [] {
            guard let trailMakingResult = stepResult as? ORKTrailmakingResult else {
                continue
            }

            guard let timestamp = trailMakingResult.taps.last?.timestamp else {
                continue
            }

            let parsedResult = AssessmentResult(
                testDateTime: Date(),
                timeSpent: timestamp,
                errorCnt: Int(trailMakingResult.numberOfErrors)
            )
            return parsedResult
        }
    }
    return nil
}


#if DEBUG
#Preview {
    TrailMakingTaskView()
        .environment(AssessmentResults())
}
#endif
