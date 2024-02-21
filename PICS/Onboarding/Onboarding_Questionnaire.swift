//
//  Onboarding_Questionnaire.swift
//  PICS
//
//  Created by Catherine Zhang on 2/13/24.
//

import SwiftUI
import SpeziQuestionnaire
import SpeziOnboarding

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
