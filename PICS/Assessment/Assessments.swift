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
        case reactionTime
    }
    
    // Binding to control the display of account-related UI.
    @Binding private var presentingAccount: Bool
    
    // Local storage of results of the Trail Making and Stroop tests for test results for layerplotting, analysis etc.
    @AppStorage("trailMakingResults") private var tmStorageResults: [AssessmentResult] = []
    @AppStorage("stroopTestResults") private var stroopTestResults: [AssessmentResult] = []
    @AppStorage("reactionTimeResults") private var reactionTimeResults: [AssessmentResult] = []

    // Tracks which test is currently selected.
    @State var currentTest = Assessments.trailMaking
    // New property to control the sheet presentation
    @State private var showingTestSheet = false
    
    // Main body of the Assessments view, switching between the list of assessments and the currently active assessment.
    var assessmentList: some View {
        List {
            trailMakingTestSection
                .padding(10)
            stroopTestSection
                .padding(10)
            reactionTimeSection
                .padding(10)
        }
    }
    
    var body: some View {
        NavigationStack {
            assessmentList
                .navigationTitle(String(localized: "ASSESSMENTS_NAVIGATION_TITLE"))
                .toolbar {
                    if AccountButton.shouldDisplay {
                        AccountButton(isPresented: $presentingAccount)
                    }
                }
        }
        .sheet(isPresented: $showingTestSheet) {
            // Determine which assessment view to present based on the currentTest state
            switch currentTest {
            case .trailMaking:
                TrailMakingTaskView()
            case .stroopTest:
                StroopTestView()
            case .reactionTime:
                ReactionTimeView()
            }
        }
        .onAppear {
            if FeatureFlags.mockTestData {
                // Set mock test data for --mockTestData feature data.
                let resultsWithTimeError = AssessmentResult(testDateTime: Date(), timeSpent: 10, errorCnt: 5)
                tmStorageResults = [resultsWithTimeError]
                stroopTestResults = [resultsWithTimeError]
                // We only record time spent for reactionTimeResults.
                reactionTimeResults = [AssessmentResult(testDateTime: Date(), timeSpent: 10)]
            }
        }
    }
        
    private var trailMakingTestSection: some View {
        // Button text to start the Trail Making Test or view results based on whether results are available.
        let btnText = if tmStorageResults.isEmpty {
            String(localized: "ASSESSMENT_TM_START_BTN")
        } else {
            String(localized: "ASSESSMENT_RESULTS_BTN")
        }
        return Section {
            VStack {
                trailMakingTestResultsView
                Divider()
                    .padding(.bottom, 5)
                Button(action: startTrailMaking) {
                    Text(btnText)
                        .foregroundStyle(.accent)
                }
                .accessibility(identifier: "startTrailMakingTestButton")
                // Use style to restrict clickable area.
                .buttonStyle(.plain)
            }
        }
    }
    
    private var stroopTestSection: some View {
        // Button text to start the Stroop Test or view results based on whether results are available.
        let btnText = if stroopTestResults.isEmpty {
            String(localized: "ASSESSMENT_STROOP_START_BTN")
        } else {
            String(localized: "ASSESSMENT_RESULTS_BTN")
        }
        return Section {
            VStack {
                stroopTestResultsView
                Divider()
                    .padding(.bottom, 5)
                Button(action: startStroopTest) {
                    Text(btnText)
                        .foregroundStyle(.accent)
                }
                .accessibility(identifier: "startStroopTestButton")
                // Use style to restrict clickable area.
                .buttonStyle(.plain)
            }
        }
    }
    private var reactionTimeSection: some View {
        // Button text to start the ReactionTime Test or view results
        // based on whether results are available.
        let btnText = if reactionTimeResults.isEmpty {
            String(localized: "ASSESSMENT_STROOP_START_BTN")
        } else {
            String(localized: "ASSESSMENT_RESULTS_BTN")
        }
        return Section {
            VStack {
                reactionTimeResultsView
                Divider()
                    .padding(.bottom, 5)
                Button(action: startReactionTimeTest) {
                    Text(btnText)
                        .foregroundStyle(.accent)
                }
                .accessibility(identifier: "startReactimeTestButton")
                // Use style to restrict clickable area.
                .buttonStyle(.plain)
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
    // Views for displaying results of the ReactionTime test, or a message indicating the test has not been completed.
    private var reactionTimeResultsView: some View {
        Group {
            if reactionTimeResults.isEmpty {
                notCompletedView(testName: "Reaction Time Test")
            } else {
                ResultsViz(
                    data: reactionTimeResults,
                    xName: "Time",
                    yName: "Results",
                    title: String(localized: "REACTIONTIME_VIZ_TITLE")
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
        showingTestSheet.toggle()
    }
    
    // Function to set up and start the Stroop Test.
    func startStroopTest() {
        currentTest = Assessments.stroopTest
        showingTestSheet.toggle()
    }
    // Function to set up and start the ReactionTime Test.
    func startReactionTimeTest() {
        currentTest = Assessments.reactionTime
        showingTestSheet.toggle()
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
            Text("This test measures your \(testName == "Trail Making" ? "visual attention and task switching" : "cognitive flexibility and processing speed").")
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
        .environment(AppointmentInformation())
}
#endif
