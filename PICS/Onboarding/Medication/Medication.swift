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
    @Environment(OnboardingNavigationPath.self)
    private var onboardingNavigationPath
    @State var image: UIImage?

    
    var body: some View {
        OnboardingView(
            contentView: {
                VStack {
                    OnboardingTitleView(
                        title: "MEDICATION_TITLE",
                        subtitle: "MEDICATION_SUBTITLE"
                    )
                    Spacer()
                    ImageCanvas(image: $image)
                }
            }, actionView: {
                OnboardingActionsView(
                    "Upload Photo",
                    action: {
                        onboardingNavigationPath.nextStep()
                    }
                )
                    .disabled(image == nil)
            }
        )
    }
}


#if DEBUG
#Preview {
    OnboardingStack {
        Medication()
    }
        .previewWith(standard: PICSStandard()) {}
}
#endif
