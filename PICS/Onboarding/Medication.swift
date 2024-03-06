//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import Foundation
import SpeziHealthKit
import SpeziOnboarding
import SwiftUI


struct Medication: View {
    @Environment(OnboardingNavigationPath.self) private var onboardingNavigationPath

    var body: some View {
        OnboardingView(
            contentView: {
                VStack {
                    OnboardingTitleView(
                        title: "MEDICATION_TITLE",
                        subtitle: "MEDICATION_SUBTITLE"
                    )
                    Spacer()
                    ContentView()
                }
            }, actionView: {
                OnboardingActionsView(
                    "Upload Photo",
                    action: {
                        onboardingNavigationPath.nextStep()
                    }
                )
            }
        )
            
            // Small fix as otherwise "Login" or "Sign up" is still shown in the nav bar
            .navigationTitle("medication")
    }
}


#if DEBUG
#Preview {
    OnboardingStack {
        Medication()
    }
        .previewWith(standard: PICSStandard()) {
        }
}
#endif
