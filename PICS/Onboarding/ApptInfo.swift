//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziOnboarding
import SwiftUI

struct DateTimePickerView: View {
    @Binding var selectedDateTime: Date

    var body: some View {
        DatePicker("Date and Time:", selection: $selectedDateTime, displayedComponents: [.date, .hourAndMinute])
    }
}


struct ApptInfo: View {
    @Environment(OnboardingNavigationPath.self)
    private var onboardingNavigationPath
    @Environment(PatientInformation.self)
    private var patientInformation

    @State private var appt0 = Date()
    @State private var appt1 = Date()
    @State private var appt2 = Date()

    var body: some View {
        OnboardingView(
            titleView: {
                OnboardingTitleView(title: "APPTQ_TITLE", subtitle: "APPTQ_SUBTITLE")
            },
            contentView: {
                VStack {
                    Text("APPTQ_0")
                       .font(.headline)
                    DateTimePickerView(selectedDateTime: $appt0)
                        .padding(.bottom, 32)
                    Text("APPTQ_1")
                       .font(.headline)
                    DateTimePickerView(selectedDateTime: $appt1)
                        .padding(.bottom, 32)
                    Text("APPTQ_2")
                       .font(.headline)
                    DateTimePickerView(selectedDateTime: $appt2)
                }
            },
            actionView: {
                OnboardingActionsView("INTERESTING_MODULES_BUTTON") {
                    patientInformation.storeDates(appt0, appt1, appt2)
                  
                    onboardingNavigationPath.nextStep()
                }
            }
        )
        .padding(.top, 24)
    }
}


#if DEBUG
#Preview {
    OnboardingStack {
        ApptInfo()
    }
        .environment(PatientInformation())
}
#endif
