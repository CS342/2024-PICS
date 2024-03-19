//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziQuestionnaire
import SwiftUI


struct PersonalInformationQuestionnaire: View {
    private let onCompletion: () -> Void

    @Environment(\.dismiss)
    private var dismiss

    @Environment(PICSStandard.self)
    private var standard
    @Environment(PatientInformation.self)
    private var patientInformation

    var body: some View {
        QuestionnaireView(
            questionnaire: Bundle.main.questionnaire(withName: "Onboarding-Questionnaire")
        ) { result in
            dismiss()

            guard case let .completed(response) = result else {
                return // user cancelled
            }
            patientInformation.isSurveyCompleted = true

            await standard.add(response: response)
            onCompletion()
        }
    }


    init(onCompletion: @escaping () -> Void = {}) {
        self.onCompletion = onCompletion
    }
}


#if DEBUG
#Preview {
    PersonalInformationQuestionnaire()
        .environment(PatientInformation())
        .previewWith(standard: PICSStandard()) {}
}
#endif
