//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

//
//  GettingThere.swift
//  PICS
//
//  Created by Akanshya Bhat on 2/5/24.
//

import Foundation
import SwiftUI

struct GettingThere: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text(String(localized: "GETTING_HERE_HEADING"))
                .font(.title2)
            MapView()
                .frame(height: 200)
            Text(String(localized: "LOCATION_NAME"))
                .font(.title3)
            HStack {
                Text(String(localized: "STREET_ADDRESS"))
                Spacer()
                Text(String(localized: "ZIP_CITY"))
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            Text("")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}
