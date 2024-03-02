//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import SpeziOnboarding
import SpeziQuestionnaire
import SwiftUI
struct OnboardingQuestionnaire: View {
    @Environment(OnboardingNavigationPath.self) private var onboardingNavigationPath
    var body: some View {
        QuestionnaireView(
            questionnaire: Bundle.main.questionnaire(withName: "Onboarding-Questionnaire")
        ) { result in
            guard case let .completed(response) = result else {
                return // user cancelled
            }
            onboardingNavigationPath.nextStep()
                            // ... save the FHIR response to your data store
        }
    }
}

#Preview {
    OnboardingStack {
        OnboardingQuestionnaire()
    }
}
