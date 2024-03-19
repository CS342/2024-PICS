//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct AssessmentNotCompletedView: View {
    private let task: AssessmentTask


    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // Displays a warning icon and a message stating the test has not been completed.
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.accentColor)
                    .accessibilityHidden(true)
                Text("\(task.testName): Not Completed")
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
                .font(.title3)
                .bold()
                .padding(.bottom, 5)
            Text(task.testDescription)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity)
                .font(.subheadline)
                .padding(.bottom, 5)
        }
            .multilineTextAlignment(.center)
    }


    init(task: AssessmentTask) {
        self.task = task
    }
}


#if DEBUG
#Preview {
    AssessmentNotCompletedView(task: .trailMaking)
}
#endif
