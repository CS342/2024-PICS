//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

//
//  AppointmentView.swift
//  PICS
//
//  Created by Akanshya Bhat on 2/1/24.
//

import SwiftUI

struct AppointmentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                AppointmentBlock(date: "June 24, 2024", time: "4:00 PM")
                AppointmentBlock(date: "September 24, 2024", time: "4:00 PM")
            }
            .padding()
            
            Divider()
            
            GettingThere()

            Spacer()
        }
        .background(Color(UIColor.systemGray6))
    }
}

#Preview {
    AppointmentView()
}
