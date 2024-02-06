//
//  MapView.swift
//  PICS
//
//  Created by Akanshya Bhat on 2/1/24.
//

import Contacts
import MapKit
import SwiftUI

struct MapView: View {
    var body: some View {
        Map(initialPosition: .region(region))
    }
    
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 52.542330, longitude: 13.347440),
            span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        )
    }
}

#Preview {
    MapView()
}
