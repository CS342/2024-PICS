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
    @Environment(OnboardingNavigationPath.self) private var onboardingNavigationPath
    
    // Define keys for AppStorage
    private let appt0Key = "appt0"
    private let appt1Key = "appt1"
    private let appt2Key = "appt2"

    // Use @AppStorage to store the selected dates
    @AppStorage("appt0") private var appt0Data: Data?
    @AppStorage("appt1") private var appt1Data: Data?
    @AppStorage("appt2") private var appt2Data: Data?

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
                    Text(String(localized: "APPTQ_0"))
                                           .font(.headline)
                    DateTimePickerView(selectedDateTime: $appt0)
                        .padding(.bottom, 32)
                    Text(String(localized: "APPTQ_1"))
                                           .font(.headline)
                    DateTimePickerView(selectedDateTime: $appt1)
                        .padding(.bottom, 32)
                    Text(String(localized: "APPTQ_2"))
                                           .font(.headline)
                    DateTimePickerView(selectedDateTime: $appt2)
                }
            },
            actionView: {
                OnboardingActionsView("INTERESTING_MODULES_BUTTON") {
                    appt1Data = try? JSONEncoder().encode(appt1)
                    appt2Data = try? JSONEncoder().encode(appt2)
                    
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
}
#endif
