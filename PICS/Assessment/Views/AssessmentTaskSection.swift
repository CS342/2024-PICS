//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct AssessmentTaskSection: View {
    private let task: AssessmentTask

    @Environment(AssessmentResults.self)
    private var results

    @Binding private var presentingTask: AssessmentTask?


    var body: some View {
        Section {
            VStack {
                if results[keyPath: task.resultsKey].isEmpty {
                    AssessmentNotCompletedView(task: task)
                } else {
                    ResultsViz(task: task, data: results[keyPath: task.resultsKey])
                }

                Divider()

                Button(action: {
                    presentingTask = task
                }) {
                    if results[keyPath: task.resultsKey].isEmpty {
                        Text("Start Assessment")
                    } else {
                        Text("Retake Assessment")
                    }
                }
                    .padding(.vertical, 4)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.accent)
                    .accessibilityIdentifier(task.accessibilityIdentifier)
                    .buttonStyle(.plain) // Use style to restrict clickable area.
            }
        }
    }


    init(task: AssessmentTask, presentingTask: Binding<AssessmentTask?>) {
        self.task = task
        self._presentingTask = presentingTask
    }
}


#if DEBUG
#Preview {
    List {
        AssessmentTaskSection(task: .trailMaking, presentingTask: .constant(nil))
    }
        .environment(AssessmentResults())
}
#endif
