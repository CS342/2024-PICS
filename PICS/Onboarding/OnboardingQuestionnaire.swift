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
    @Environment(PICSStandard.self) private var standard
    @AppStorage("isSurveyCompleted") var isSurveyCompleted = false
    @Binding var isSheetPresented: Bool

    var body: some View {
        QuestionnaireView(
            questionnaire: Bundle.main.questionnaire(withName: "Onboarding-Questionnaire")
        ) { result in
            guard case let .completed(response) = result else {
                isSheetPresented = false
                onboardingNavigationPath.nextStep()
                return // user cancelled
            }
            isSurveyCompleted = true
            isSheetPresented = false
            await standard.add(response: response)
            onboardingNavigationPath.nextStep()
        }
    }
}

#Preview {
    OnboardingStack {
        OnboardingQuestionnaire(isSheetPresented: .constant(true))
    }
        .previewWith(standard: PICSStandard()) {}
}
