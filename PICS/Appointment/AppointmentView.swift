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
            } header: {
                Circle() // workaround for weird spacing issue
                    .foregroundColor(Color.clear)
                    .frame(height: 0)
            }

            Section {
                VStack(alignment: .leading) {
                    Text("TIMELINE_TITLE")
                        .foregroundColor(.primary)
                        .bold()
                        .padding(.bottom)
                        .accessibilityAddTraits(.isHeader)
                    TimelineView()
                }
                .padding(.vertical, 8)
            }

            Section {
                GettingThere()
            }
        }
            .navigationTitle("APPOINTMENTS_NAVIGATION_TITLE")
            .sheet(isPresented: $showingEdit) {
                // swiftlint:disable:previous closure_body_length
                NavigationStack {
                    List {
                        Section {
                            Text("APPTQ_0")
                                .font(.headline)
                            DateTimePickerView(selectedDateTime: $appt0User)
                        }
                        Section {
                            Text("APPTQ_1")
                                .font(.headline)
                            DateTimePickerView(selectedDateTime: $appt1User)
                        }
                        Section {
                            Text("APPTQ_2")
                                .font(.headline)
                            DateTimePickerView(selectedDateTime: $appt2User)
                        }

                        Button(action: {
                            patientInformation.storeDates(appt0User, appt1User, appt2User)
                            showingEdit.toggle()
                        }) {
                            Text("SAVE_BUTTON")
                                .frame(maxWidth: .infinity)
                        }
                    }
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
