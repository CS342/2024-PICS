//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftUI

// TODO: remove all String(localized: ?


struct GettingThere: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("GETTING_HERE_HEADING")
                .font(.title2)
            MapView()
                .frame(height: 200)
            Text("LOCATION_NAME")
                .font(.title3)
            HStack {
                Text("STREET_ADDRESS")
                Spacer()
                Text("ZIP_CITY")
            }
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
            .padding() // TODO: remove?
    }
}


#if DEBUG
#Preview {
    GettingThere()
}
#endif
