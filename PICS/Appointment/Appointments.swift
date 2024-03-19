//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//
import Foundation
import SwiftUI


/// Displays the contacts for the PICS.
struct Appointments: View {
    @Binding var presentingAccount: Bool
    
    var body: some View {
        NavigationStack {
            AppointmentView()
                .toolbar {
                    if AccountButton.shouldDisplay {
                        AccountButton(isPresented: $presentingAccount)
                    }
                }
        }
    }
    
    
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
}


#if DEBUG
#Preview {
    Appointments(presentingAccount: .constant(false))
        .environment(PatientInformation())
}
#endif
