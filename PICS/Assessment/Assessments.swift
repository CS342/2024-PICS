//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct Assessments: View {
    @State private var assessmentResults = AssessmentResults()
    @State private var presentedTask: AssessmentTask?

    @Binding private var presentingAccount: Bool

    var body: some View {
        NavigationStack {
            List {
                AssessmentTaskSection(task: .trailMaking, presentingTask: $presentedTask)
                AssessmentTaskSection(task: .stroopTest, presentingTask: $presentedTask)
                AssessmentTaskSection(task: .reactionTime, presentingTask: $presentedTask)
            }
                .navigationTitle("ASSESSMENTS_NAVIGATION_TITLE")
                .toolbar {
                    if AccountButton.shouldDisplay {
                        AccountButton(isPresented: $presentingAccount)
                    }
                }
        }
            .onAppear {
                if FeatureFlags.mockTestData {
                    assessmentResults.setTestMockData()
                }
            }
            .sheet(item: $presentedTask) { task in
                Group {
                    switch task {
                    case .trailMaking:
                        TrailMakingTaskView()
                    case .stroopTest:
                        StroopTestView()
                    case .reactionTime:
                        ReactionTimeView()
                    }
                }
                    .background(Color(uiColor: .systemGroupedBackground)) // fix ResearchKit background color
                    .interactiveDismissDisabled()
            }
            .environment(assessmentResults)
    }


    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
}


#if DEBUG
#Preview("AssessmentView") {
    Assessments(presentingAccount: .constant(false))
        .environment(PatientInformation())
}
#endif
