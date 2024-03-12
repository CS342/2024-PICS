//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct AppointmentView: View {
    @Environment(AppointmentInformation.self) private var appointmentInfo
    @State private var showingEdit = false
    
    @State private var appt0User = Date()
    @State private var appt1User = Date()
    @State private var appt2User = Date()
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading) {
                AppointmentBlock(date: formattedDate(appointmentInfo.appt1), time: formattedTime(appointmentInfo.appt1))
                AppointmentBlock(date: formattedDate(appointmentInfo.appt2), time: formattedTime(appointmentInfo.appt2))
                    .padding(.bottom)
                HStack {
                    Button(String(localized: "RESCHEDULE_BUTTON_LABEL")) {
                        showingEdit.toggle()
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.bottom)
                Text(String(localized: "TIMELINE_TITLE"))
                    .foregroundColor(.primary)
                    .italic()
                TimelineView()
            }
            .padding()
            
            Divider()
                .overlay(Color.secondary)
                .frame(width: 340)
            
            GettingThere()

            Spacer()
        }
        .sheet(isPresented: $showingEdit) {
            NavigationView {
                VStack {
                    Text(String(localized: "APPTQ_0"))
                        .font(.headline)
                        .padding(.top, 32)
                    DateTimePickerView(selectedDateTime: $appt0User)
                        .padding(.bottom, 32)
                    Text(String(localized: "APPTQ_1"))
                        .font(.headline)
                    DateTimePickerView(selectedDateTime: $appt1User)
                        .padding(.bottom, 32)
                    Text(String(localized: "APPTQ_2"))
                        .font(.headline)
                    DateTimePickerView(selectedDateTime: $appt2User)
                        .padding(.bottom, 32)
                    Button(String(localized: "SAVE_BUTTON")) {
                        appointmentInfo.storeDates(appt0User, appt1User, appt2User)
                        showingEdit.toggle()
                    }
                    .buttonStyle(.bordered)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .navigationTitle(String(localized: "EDIT_APPT_HEADER"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(String(localized: "CLOSE")) {
                            showingEdit.toggle()
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
        }
        .background(Color(UIColor.systemBackground))
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
