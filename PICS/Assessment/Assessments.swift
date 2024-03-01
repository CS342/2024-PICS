//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

// Struct for all the Assessments. The positive errorCnt and score
// will be plot in ResultsViz.
struct AssessmentResult: Codable, Identifiable {
    var testDateTime: Date
    var timeSpent: Double
    var errorCnt: Int = -1
    // Score that might be collected for MiniCog.
    var score: Int = -1
    var id = UUID()
}

struct Assessments: View {
    enum Assessments {
        case trailMaking
    }

    @Environment(PICSStandard.self) private var standard
    @Environment(PICSScheduler.self) private var scheduler
    
    @Binding private var presentingAccount: Bool
    
    // Local storages for test results for plotting, etc.
    @AppStorage("trailMakingResults") private var tmStorageResults: [AssessmentResult] = []
    // Decide whether to show test or not.
    @AppStorage("AssessmentsInProgress") private var assessmentsIP = false
    
    @State var currentTest = Assessments.trailMaking
    
    var assessmentList: some View {
        List {
            Section {
                VStack {
                    ResultsViz(
                        data: tmStorageResults,
                        xName: "Time",
                        yName: "Results",
                        title: String(localized: "TM_VIZ_TITLE")
                    )
                    Button(action: startTrailMaking) {
                        Text(String(localized: "ASSESSMENT_TM_START_BTN"))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            // Add Stroop test and cognitive test here.
        }
    }
    
    
    var body: some View {
        NavigationStack {
            if assessmentsIP {
                switch currentTest {
                case Assessments.trailMaking:
                    TrailMakingTaskView()
                }
            } else {
                assessmentList
                    .navigationTitle(String(localized: "ASSESSMENTS_NAVIGATION_TITLE"))
                    .toolbar {
                        if AccountButton.shouldDisplay {
                            AccountButton(isPresented: $presentingAccount)
                        }
                    }
            }
        }
    }
    
    
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
    
    func startTrailMaking() {
        currentTest = Assessments.trailMaking
        assessmentsIP = true
    }
}

#if DEBUG
#Preview("AssessmentView") {
    Assessments(presentingAccount: .constant(false))
}
#endif
