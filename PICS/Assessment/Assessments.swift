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
                        StroopTestView() // You'll need to create this view
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
        
        // ... other methods ...
        
        // Refactored Trail Making Test Section View
        private var trailMakingTestSection: some View {
            Section {
                VStack {
                    trailMakingTestResultsView
                    Divider()
                    Button(action: startTrailMaking) {
                        Text(String(localized: "ASSESSMENT_TM_START_BTN"))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        
        // Refactored Stroop Test Section View
        private var stroopTestSection: some View {
            Section {
                VStack {
                    stroopTestResultsView
                    Divider()
                    Button(action: startStroopTest) {
                        Text(String(localized: "ASSESSMENT_STROOP_START_BTN"))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        
        // Reusable subviews for result or not completed message
        private var trailMakingTestResultsView: some View {
            Group {
                if tmStorageResults.isEmpty {
                    notCompletedView(testName: "Trail Making Test")
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
        
        // Subview for the not completed message
        private func notCompletedView(testName: String) -> some View {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(testName): Not Completed")
                        .font(.title3.bold())
//                        .font(.title)
//                        .bold()
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 25))
                        .accessibilityHidden(true)
                }
                .padding(.bottom, 5)
                .multilineTextAlignment(.center) // Center-align this Text
                Text("This test measures your \(testName == "Trail Making Test" ? "visual attention and task switching" : "cognitive flexibility and processing speed").")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center) // Center-align this Text
                    .frame(maxWidth: .infinity) // Ensure the Text view expands to the width of its container
                    .font(.subheadline)
                    .padding(.bottom, 5)
            }
        }
    
//    var assessmentList: some View {
//        List {
//            Section {
//                VStack {
//                    if tmStorageResults.isEmpty {
//                        HStack {
//                            Image(systemName: "exclamationmark.circle.fill")
//                                .foregroundColor(.yellow)
//                                .font(.system(size: 30))
//                                .accessibilityHidden(true)
//                            Text("Trail Making Test - Not Completed")
//                                .foregroundColor(.primary)
//                        }
//                        Text("This test measures your visual attention and task switching. It has not been completed yet.")
//                            .foregroundColor(.secondary)
//                            .font(.subheadline)
//                    } else {
//                        ResultsViz(
//                            data: tmStorageResults,
//                            xName: "Time",
//                            yName: "Results",
//                            title: String(localized: "TM_VIZ_TITLE")
//                        )
//                    }
////                    ResultsViz(
////                        data: tmStorageResults,
////                        xName: "Time",
////                        yName: "Results",
////                        title: String(localized: "TM_VIZ_TITLE")
////                    )
//                    Button(action: startTrailMaking) {
//                        Text(String(localized: "ASSESSMENT_TM_START_BTN"))
//                    }
//                    .frame(maxWidth: .infinity)
//                }
//            }
//            Section {
//                VStack {
//                    if stroopTestResults.isEmpty {
//                        HStack {
//                            Image(systemName: "exclamationmark.circle.fill")
//                                .foregroundColor(.yellow)
//                                .font(.system(size: 30))
//                                .accessibilityHidden(true)
//                        }
//                        Text("The Stroop test assesses your cognitive flexibility and processing speed. It has not been completed yet.")
//                            .foregroundColor(.secondary)
//                            .font(.subheadline)
//                    } else {
//                        ResultsViz(
//                            data: stroopTestResults,
//                            xName: "Time",
//                            yName: "Results",
//                            title: String(localized: "STROOP_VIZ_TITLE")
//                        )
//                    }
////                    ResultsViz(
////                        data: stroopTestResults,
////                        xName: "Time",
////                        yName: "Results",
////                        title: String(localized: "STROOP_VIZ_TITLE")
////                    )
//                    Button(action: startStroopTest) {
//                        Text(String(localized: "ASSESSMENT_STROOP_START_BTN"))
//                    }
//                    .frame(maxWidth: .infinity)
//                }
//            }
//            // Add Stroop test and cognitive test here.
//        }
//    }
    
    
//    var body: some View {
//        NavigationStack {
////            if assessmentsIP {
////                switch currentTest {
////                case Assessments.trailMaking:
////                    TrailMakingTaskView()
////                }
//            if assessmentsIP {
//                switch currentTest {
//                case .trailMaking:
//                    TrailMakingTaskView()
//                case .stroopTest:
//                    StroopTestView() // You'll need to create this view
//                }
//            } else {
//                assessmentList
//                    .navigationTitle(String(localized: "ASSESSMENTS_NAVIGATION_TITLE"))
//                    .toolbar {
//                        if AccountButton.shouldDisplay {
//                            AccountButton(isPresented: $presentingAccount)
//                        }
//                    }
//            }
//        }
//    }
    
    
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
