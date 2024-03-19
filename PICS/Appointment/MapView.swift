//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Contacts
import MapKit
import OSLog
import SwiftUI


struct MapView: View {
    private let logger = Logger(subsystem: "de.charité", category: "MapView")

    @State private var searchResult: MKMapItem?
    @State private var showOpenConfirmation = false

    private var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: 52.542330, longitude: 13.347440)
    }

    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        )
    }

    private var mapItem: MKMapItem {
        let address = CNMutablePostalAddress()
        address.country = "Germany"
        address.postalCode = "13353"
        address.city = "Berlin"
        address.street = "Augustenburger Pl. 1"

        let placemark = MKPlacemark(coordinate: coordinate, postalAddress: address)
        return MKMapItem(placemark: placemark)
    }

    var body: some View {
        Map(initialPosition: .region(region), interactionModes: [.zoom, .rotate]) {
            Marker(item: searchResult ?? mapItem)
        }
            .confirmationDialog("Get Directions", isPresented: $showOpenConfirmation) {
                Button("Open in Apple Maps") {
                    (searchResult ?? mapItem).openInMaps()
                }
                Button("Cancel", role: .cancel) {}
            }
            .onTapGesture {
                showOpenConfirmation = true
            }
            .task {
                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = "Charité"
                searchRequest.resultTypes = .pointOfInterest
                searchRequest.region = region

                let search = MKLocalSearch(request: searchRequest)
                do {
                    let response = try await search.start()
                    searchResult = response.mapItems.first { item in
                        item.name == "Charité"
                            && item.pointOfInterestCategory == .hospital
                    }
                } catch {
                    // we just show our backup point
                    logger.warning("Failed to query Charité point of interest: \(error)")
                }
            }
    }
}


#if DEBUG
#Preview {
    MapView()
}
#endif
