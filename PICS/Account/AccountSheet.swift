//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SwiftUI


struct AccountSheet: View {
    @Environment(\.dismiss)
    private var dismiss

    @Environment(Account.self)
    private var account
    @Environment(PatientInformation.self)
    private var patientInformation

    @Environment(\.accountRequired)
    private var accountRequired

    @State var isInSetup = false
    @State var overviewIsEditing = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                if account.signedIn && !isInSetup {
                    AccountOverview(isEditing: $overviewIsEditing) {
                        healthSection

                        NavigationLink("LICENSE_INFO_TITLE") {
                            ContributionsList()
                        }
                    }
                        .onDisappear {
                            overviewIsEditing = false
                        }
                        .toolbar {
                            if !overviewIsEditing {
                                closeButton
                            }
                        }
                } else {
                    AccountSetup { _ in
                        dismiss() // we just signed in, dismiss the account setup sheet
                    } header: {
                        AccountSetupHeader()
                    }
                        .onAppear {
                            isInSetup = true
                        }
                        .toolbar {
                            if !accountRequired {
                                closeButton
                            }
                        }
                }
            }
        }
    }

    @ViewBuilder var healthSection: some View {
        @Bindable var patientInformation = patientInformation
        Section("Health") {
            Stepper(value: $patientInformation.minimumStepCount, in: 2000...15000, step: 200) {
                VStack(alignment: .leading) {
                    Text("Recommended Step Count")
                    Text("\(patientInformation.minimumStepCount) steps")
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    var closeButton: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("CLOSE") {
                dismiss()
            }
        }
    }
}


#if DEBUG
#Preview("AccountSheet") {
    let details = AccountDetails.Builder()
        .set(\.userId, value: "lelandstanford@stanford.edu")
        .set(\.name, value: PersonNameComponents(givenName: "Leland", familyName: "Stanford"))
    
    return AccountSheet()
        .previewWith {
            AccountConfiguration(building: details, active: MockUserIdPasswordAccountService())
        }
}

#Preview("AccountSheet SignIn") {
    AccountSheet()
        .environment(PatientInformation())
        .previewWith {
            AccountConfiguration {
                MockUserIdPasswordAccountService()
            }
        }
}
#endif
