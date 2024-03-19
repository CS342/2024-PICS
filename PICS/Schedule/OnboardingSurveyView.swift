//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import SwiftUI

struct OnboardingSurveyView: View {
    @Environment(PICSStandard.self)
    private var standard

    @State var isSheetPresented = false

    var body: some View {
        HStack {
            onboardingSurveyDetailsStack
        }
            .contentShape(Rectangle())
    }
    
    private var onboardingSurveyDetailsStack: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) { // Align items to top
                statusIcon
                VStack(alignment: .leading) {
                    Text("Onboarding Questionnaire")
                        .font(.headline)
                    Text("Now")
                        .font(.subheadline)
                }
            }
            Divider()
            descriptionText
            actionTypeText
        }
    }
    
    private var statusIcon: some View {
        Image(systemName: "exclamationmark.circle.fill")
            .foregroundColor(.yellow)
            .font(.system(size: 30))
            .accessibilityHidden(true)
    }
    
    private var descriptionText: some View {
        Text("ONBOARDING_CAPTION")
            .font(.callout)
    }
    
    private var actionTypeText: some View {
        Button(action: {
            isSheetPresented = true
        }) {
            Text("Start Questionnaire")
                .frame(maxWidth: .infinity, minHeight: 50)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.top, 8)
        }
            .sheet(isPresented: $isSheetPresented) {
                PersonalInformationQuestionnaire()
            }
    }
}

#if DEBUG
struct OnboardingSurveyView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingSurveyView()
            .padding()
    }
}
#endif
