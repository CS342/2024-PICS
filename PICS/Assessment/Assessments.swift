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
    // Enum to differentiate between available assessments.
    enum Assessments {
        case trailMaking
        case stroopTest
    }

    // Environment objects for app-wide settings and scheduling.
    @Environment(PICSStandard.self) private var standard
    @Environment(PICSScheduler.self) private var scheduler
    
    // Binding to control the display of account-related UI.
    @Binding private var presentingAccount: Bool
    
    // Local storage of results of the Trail Making and Stroop tests for test results for layerplotting, analysis etc.
    @AppStorage("trailMakingResults") private var tmStorageResults: [AssessmentResult] = []
    @AppStorage("stroopTestResults") private var stroopTestResults: [AssessmentResult] = []
    // Decide whether to show test or not.
    @AppStorage("AssessmentsInProgress") private var assessmentsIP = false
    // Tracks which test is currently selected.
    @State var currentTest = Assessments.trailMaking
    
    // Main body of the Assessments view, switching between the list of assessments and the currently active assessment.
    var assessmentList: some View {
            List {
                trailMakingTestSection
                stroopTestSection
            }
        }
        
        var body: some View {
            NavigationStack {
                if assessmentsIP {
                    // Displays the active assessment based on the currentTest state.
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
                // Button to start the Trail Making Test or view results, based on whether results are available.
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
                // Button to start the Stroop Test or view results, based on whether results are available.
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
        
    // Views for displaying results of Trail Making, or a message indicating the test has not been completed.
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
    
    // Views for displaying results of the Stroop test, or a message indicating the test has not been completed.
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
    
    // Initializes the view with a binding to control whether the account UI is being presented.
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
    
    // Function to set up and start the Trail Making assessment.
    func startTrailMaking() {
        currentTest = Assessments.trailMaking
        assessmentsIP = true
    }
    
    // Function to set up and start the Stroop Test.
    func startStroopTest() {
        currentTest = Assessments.stroopTest
        assessmentsIP = true
    }
    
    // A view for displaying a message indicating that a specific assessment has not been completed.
    private func notCompletedView(testName: String) -> some View {
        VStack(alignment: .leading) {
            HStack {
                // Displays a warning icon and a message stating the test has not been completed.
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
}

#if DEBUG
#Preview("AssessmentView") {
    Assessments(presentingAccount: .constant(false))
}
#endif
