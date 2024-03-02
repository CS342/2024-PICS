//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct AppointmentView: View {
    @Environment(AppointmentInformation.self) private var appointmentInfo
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                AppointmentBlock(date: formattedDate(appointmentInfo.appt1), time: formattedTime(appointmentInfo.appt1))
                AppointmentBlock(date: formattedDate(appointmentInfo.appt2), time: formattedTime(appointmentInfo.appt2))
                    .padding(.bottom)
                Text(String(localized: "TIMELINE_TITLE"))
                    .foregroundColor(.black)
                    .italic()
                TimelineView()
            }
            .padding()
            
            Divider()
            
            GettingThere()

            Spacer()
        }
        .background(Color(UIColor.systemGray6))
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
        .environment(AppointmentInformation())
}
