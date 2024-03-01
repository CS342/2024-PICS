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
        case stroopTest
    }

    @Environment(PICSStandard.self) private var standard
    @Environment(PICSScheduler.self) private var scheduler
    
    @Binding private var presentingAccount: Bool
    
    // Local storages for test results for plotting, etc.
    @AppStorage("trailMakingResults") private var tmStorageResults: [AssessmentResult] = []
    @AppStorage("stroopTestResults") private var stroopTestResults: [AssessmentResult] = []
    // Decide whether to show test or not.
    @AppStorage("AssessmentsInProgress") private var assessmentsIP = false
    
    @State var currentTest = Assessments.trailMaking
    
    var assessmentList: some View {
            List {
                trailMakingTestSection
                stroopTestSection
            }
        }
        
        var body: some View {
            NavigationStack {
                if assessmentsIP {
                    switch currentTest {
                    case .trailMaking:
                        TrailMakingTaskView()
                    case .stroopTest:
                        StroopTestView()
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
        
    private var trailMakingTestSection: some View {
        Section {
            VStack {
                trailMakingTestResultsView
                Divider()
                .padding(.bottom, 5)
                if tmStorageResults.isEmpty {
                    Button(action: startTrailMaking) {
                        Text(String(localized: "ASSESSMENT_TM_START_BTN"))
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    Button(action: startTrailMaking) {
                        Text(String(localized: "ASSESSMENT_RESULTS_BTN"))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
        
    private var stroopTestSection: some View {
        Section {
            VStack {
                stroopTestResultsView
                Divider()
                    .padding(.bottom, 5)
                if stroopTestResults.isEmpty {
                    Button(action: startStroopTest) {
                        Text(String(localized: "ASSESSMENT_STROOP_START_BTN"))
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    Button(action: startStroopTest) {
                        Text(String(localized: "ASSESSMENT_RESULTS_BTN"))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
        
    private var trailMakingTestResultsView: some View {
        Group {
            if tmStorageResults.isEmpty {
                notCompletedView(testName: "Trail Making")
            } else {
                ResultsViz(
                    data: tmStorageResults,
                    xName: "Time",
                    yName: "Results",
                    title: String(localized: "TM_VIZ_TITLE")
                )
            }
        }
    }
    
    private var stroopTestResultsView: some View {
        Group {
            if stroopTestResults.isEmpty {
                notCompletedView(testName: "Stroop Test")
            } else {
                ResultsViz(
                    data: stroopTestResults,
                    xName: "Time",
                    yName: "Results",
                    title: String(localized: "STROOP_VIZ_TITLE")
                )
            }
        }
    }
    
    private func notCompletedView(testName: String) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 25))
                    .accessibilityHidden(true)
                Text("\(testName): Not Completed")
                    .font(.title3.bold())
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .padding(.bottom, 5)
            .multilineTextAlignment(.center)
            Text("This test measures your \(testName == "Trail Making Test" ? "visual attention and task switching" : "cognitive flexibility and processing speed").")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .font(.subheadline)
                .padding(.bottom, 5)
        }
    }
    
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
    
    func startTrailMaking() {
        currentTest = Assessments.trailMaking
        assessmentsIP = true
    }
    
    func startStroopTest() {
        currentTest = Assessments.stroopTest
        assessmentsIP = true
    }
}

#if DEBUG
#Preview("AssessmentView") {
    Assessments(presentingAccount: .constant(false))
}
#endif
