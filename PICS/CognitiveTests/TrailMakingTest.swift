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
    var body: some View {
        ZStack {
            Color(red: 242/255, green: 242/255, blue: 247/255)
                .edgesIgnoringSafeArea(.all)
            ORKOrderedTaskView(
                tasks: createTrailMakingTask(),
                tintColor: .accentColor,
                shouldConfirmCancel: true,
                result: handleTaskResult
            )
            .navigationBarTitle("Trail Making Task")
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
        switch result {
        case .completed(let taskResult):
            // Handle completed task result
            print("Task completed with result: \(taskResult)")
        case .cancelled:
            // Handle task cancellation
            print("Task cancelled by the user")
        case .failed(let error):
            // Handle task failure
            print("Task failed with error: \(error)")
        }
    }
}

#Preview {
    TrailMakingTaskView()
}
