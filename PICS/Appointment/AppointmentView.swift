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
        List {
            Section {
                AppointmentBlock(date: patientInformation.appt1)
                AppointmentBlock(date: patientInformation.appt2)
                Button("RESCHEDULE_BUTTON_LABEL") {
                    showingEdit.toggle()
                }
            }
            Section {
                VStack {
                    HStack {
                        Text("TIMELINE_TITLE")
                            .foregroundColor(.primary)
                            .bold()
                        Spacer()
                    }
                    .padding(.bottom)
                    TimelineView()
                }
                .padding(.horizontal, 6)
            }

            Section {
                GettingThere()
            }
        }
            .navigationTitle("APPOINTMENTS_NAVIGATION_TITLE")
            .sheet(isPresented: $showingEdit) {
                NavigationStack {
                    List {
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
                        .buttonStyle(.borderedProminent)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .navigationTitle("EDIT_APPT_HEADER")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("CLOSE") {
                                showingEdit.toggle()
                            }
                        }
                    }
                }
                .interactiveDismissDisabled()
            }
    }
}


#if DEBUG
#Preview {
    NavigationStack {
        AppointmentView()
            .environment(PatientInformation())
    }
}
#endif
