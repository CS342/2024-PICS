//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftUI


struct GettingThere: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("GETTING_HERE_HEADING")
                .font(.title2)
                .bold()
            MapView()
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(height: 200)
            Text("LOCATION_NAME")
                .font(.title3)
            HStack {
                Text("STREET_ADDRESS")
                Spacer()
                Text("ZIP_CITY")
            }
                .font(.subheadline)
        }
    }
}


#if DEBUG
#Preview {
    NavigationStack {
        List {
            GettingThere()
        }
        .navigationTitle("Test Title")
    }
}
#endif
