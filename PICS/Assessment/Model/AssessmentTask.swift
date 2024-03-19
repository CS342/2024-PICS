//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation


// Enum to differentiate between available assessments.
enum AssessmentTask: String {
    case trailMaking
    case stroopTest
    case reactionTime
}


extension AssessmentTask {
    var accessibilityIdentifier: String {
        switch self {
        case .trailMaking:
            "startTrailMakingTestButton"
        case .stroopTest:
            "startStroopTestButton"
        case .reactionTime:
            "startReactimeTestButton"
        }
    }

    var resultsKey: KeyPath<AssessmentResults, [AssessmentResult]> {
        switch self {
        case .trailMaking:
            \.tmStorageResults
        case .stroopTest:
            \.stroopTestResults
        case .reactionTime:
            \.reactionTimeResults
        }
    }

    var testName: LocalizedStringResource {
        switch self {
        case .trailMaking:
            "Trail Making"
        case .stroopTest:
            "Stroop Test"
        case .reactionTime:
            "Reaction Time"
        }
    }

    var testDescription: LocalizedStringResource {
        switch self {
        case .trailMaking:
            "This test measures your visual attention and task switching."
        case .stroopTest:
            "This test measures your cognitive flexibility and processing speed."
        case .reactionTime:
            "This test measures your speed and accuracy of response."
        }
    }

    var resultsTitle: LocalizedStringResource {
        switch self {
        case .trailMaking:
            "TM_VIZ_TITLE"
        case .stroopTest:
            "STROOP_VIZ_TITLE"
        case .reactionTime:
            "REACTIONTIME_VIZ_TITLE"
        }
    }
}


extension AssessmentTask: Identifiable {
    var id: String {
        rawValue
    }
}
