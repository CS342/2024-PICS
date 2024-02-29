//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import Foundation
import SwiftUI

struct AppointmentBlock: View {
    var date: String
    var time: String

    var body: some View {
        Color.white
            .frame(height: 120)
            .cornerRadius(15)
            .overlay(
                VStack(alignment: .leading) {
                    Spacer()
                    VStack(alignment: .leading) {
                        HStack {
                            Text(date)
                                .foregroundColor(.black)
                                .bold()
                            Spacer()
                            Text(time)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        HStack {
                            VStack(alignment: .leading) {
                                Text(String(localized: "REQUIRED_ITEMS_HEADING"))
                                    .foregroundColor(.black)
                                Text(String(localized: "REQUIRED_ITEMS_ID"))
                                    .padding(.leading, 10)
                                    .italic()
                            }
                            Spacer()
                            Button(action: reschedule) {
                                Text(String(localized: "RESCHEDULE_BUTTON_LABEL"))
                            }
                        }
                        Spacer()
                    }
                    .padding()
                }
            )
    }
    
    func reschedule() {
    }
}
