//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


@Observable
class AssessmentResults {
    @AppStorage("trailMakingResults")
    @ObservationIgnored private var _tmStorageResults: [AssessmentResult] = []
    @AppStorage("stroopTestResults")
    @ObservationIgnored private var _stroopTestResults: [AssessmentResult] = []
    @AppStorage("reactionTimeResults")
    @ObservationIgnored private var _reactionTimeResults: [AssessmentResult] = []

    var tmStorageResults: [AssessmentResult] {
        get {
            access(keyPath: \.tmStorageResults)
            return _tmStorageResults
        }
        set {
            withMutation(keyPath: \.tmStorageResults) {
                _tmStorageResults = newValue
            }
        }
    }

    var stroopTestResults: [AssessmentResult] {
        get {
            access(keyPath: \.stroopTestResults)
            return _stroopTestResults
        }
        set {
            withMutation(keyPath: \.stroopTestResults) {
                _stroopTestResults = newValue
            }
        }
    }

    var reactionTimeResults: [AssessmentResult] {
        get {
            access(keyPath: \.reactionTimeResults)
            return _reactionTimeResults
        }
        set {
            withMutation(keyPath: \.reactionTimeResults) {
                _reactionTimeResults = newValue
            }
        }
    }


    func setTestMockData() {
        // Set mock test data for --mockTestData feature data.
        let resultsWithTimeError = AssessmentResult(testDateTime: Date(), timeSpent: 10, errorCnt: 5)
        tmStorageResults = [resultsWithTimeError]
        stroopTestResults = [resultsWithTimeError]
        // We only record time spent for reactionTimeResults.
        reactionTimeResults = [AssessmentResult(testDateTime: Date(), timeSpent: 10)]
    }
}
