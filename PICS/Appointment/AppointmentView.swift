//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct AppointmentView: View {
    @Environment(PatientInformation.self)
    private var patientInformation
    @State private var showingEdit = false
    
    @State private var appt0User = Date()
    @State private var appt1User = Date()
    @State private var appt2User = Date()
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading) {
                AppointmentBlock(date: patientInformation.appt1)
                AppointmentBlock(date: patientInformation.appt2)
                    .padding(.bottom)
                HStack {
                    Button("RESCHEDULE_BUTTON_LABEL") {
                        showingEdit.toggle()
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.bottom)
                Text("TIMELINE_TITLE")
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
            NavigationStack {
                VStack {
                    Text("APPTQ_0")
                        .font(.headline)
                        .padding(.top, 32)
                    DateTimePickerView(selectedDateTime: $appt0User)
                        .padding(.bottom, 32)
                    Text("APPTQ_1")
                        .font(.headline)
                    DateTimePickerView(selectedDateTime: $appt1User)
                        .padding(.bottom, 32)
                    Text("APPTQ_2")
                        .font(.headline)
                    DateTimePickerView(selectedDateTime: $appt2User)
                        .padding(.bottom, 32)
                    Button("SAVE_BUTTON") {
                        patientInformation.storeDates(appt0User, appt1User, appt2User)
                        showingEdit.toggle()
                    }
                    .buttonStyle(.bordered)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .navigationTitle("EDIT_APPT_HEADER")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("CLOSE") {
                            showingEdit.toggle()
                        }
                    }
                }
            }
        }
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    AppointmentView()
        .environment(PatientInformation())
}
