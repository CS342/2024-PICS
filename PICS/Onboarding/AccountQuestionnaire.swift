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
    @Environment(OnboardingNavigationPath.self)
    private var onboardingNavigationPath

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
                        primaryText: "Take Questionnaire",
                        primaryAction: {
                            isSheetPresented = true
                        },
                        secondaryText: "Skip"
                    ) {
                        onboardingNavigationPath.nextStep()
                    }
                }
            }
        )
            .sheet(isPresented: $isSheetPresented) {
                PersonalInformationQuestionnaire {
                    onboardingNavigationPath.nextStep()
                }
            }
    }
}


#if DEBUG
#Preview {
    OnboardingStack {
        AccountQuestionnaire()
        Text(verbatim: "Next Page")
    }
        .previewWith(standard: PICSStandard()) {}
        .environment(PatientInformation())
}
#endif
