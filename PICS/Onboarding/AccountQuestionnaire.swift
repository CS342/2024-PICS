//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziHealthKit
import SpeziOnboarding
import SwiftUI


struct AccountQuestionnaire: View {
    @Environment(OnboardingNavigationPath.self) private var onboardingNavigationPath
    @AppStorage("isSurveyCompleted") var isSurveyCompleted = false
    @State var isSheetPresented = false
    @State private var showOnboardingQuestionnaire = false
    
    var body: some View {
        OnboardingView(
            contentView: {
                VStack {
                    OnboardingTitleView(
                        title: "ONBOARDING_TITLE",
                        subtitle: "ONBOARDING_SUBTITLE"
                    )
                    Spacer()
                    Image(systemName: "list.bullet.clipboard.fill")
                        .font(.system(size: 130))
                        .foregroundColor(.accentColor)
                        .accessibilityHidden(true)
                    Text("ONBOARDING_INSTRUCTION")
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 15)
                    Spacer()
                }
            }, actionView: {
                VStack {
                    OnboardingActionsView(
                        "Take Questionnaire",
                        action: {
                            isSheetPresented = true
                        }
                    )
                    .padding(.vertical, 16)
                    OnboardingActionsView(
                        "Skip",
                        action: {
                            onboardingNavigationPath.nextStep()
                        }
                    )
                    .sheet(isPresented: $isSheetPresented) {
                        OnboardingQuestionnaire(isSheetPresented: $isSheetPresented)
                    }
                }
            }
        )
            // .navigationBarBackButtonHidden(healthKitProcessing)
            // Small fix as otherwise "Login" or "Sign up" is still shown in the nav bar
            .navigationTitle(Text(verbatim: ""))
    }
}


#if DEBUG
#Preview {
    OnboardingStack {
        AccountQuestionnaire()
    }
        .previewWith(standard: PICSStandard()) {}
}
#endif
