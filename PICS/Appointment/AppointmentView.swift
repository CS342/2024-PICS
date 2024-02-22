//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct AppointmentView: View {
    @AppStorage("appt1") private var appt1Data: Data?
    @AppStorage("appt2") private var appt2Data: Data?

    @State private var appt1 = Date()
    @State private var appt2 = Date()
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                AppointmentBlock(date: formattedDate(appt1), time: formattedTime(appt1))
                AppointmentBlock(date: formattedDate(appt2), time: formattedTime(appt2))
            }
            .padding()
            
            Divider()
            
            GettingThere()

            Spacer()
        }
        .background(Color(UIColor.systemGray6))
        .onAppear {
                    initializeAppointments()
        }
    }
    private func initializeAppointments() {
           let decoder = JSONDecoder()
           if let appt1Data = appt1Data, let decodedAppt1 = try? decoder.decode(Date.self, from: appt1Data) {
               appt1 = decodedAppt1
           }
           if let appt2Data = appt2Data, let decodedAppt2 = try? decoder.decode(Date.self, from: appt2Data) {
               appt2 = decodedAppt2
           }
       }

       private func formattedDate(_ date: Date) -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = "MMMM dd, yyyy"
           return formatter.string(from: date)
       }

       private func formattedTime(_ date: Date) -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = "h:mm a"
           return formatter.string(from: date)
       }
}

#Preview {
    AppointmentView()
}
