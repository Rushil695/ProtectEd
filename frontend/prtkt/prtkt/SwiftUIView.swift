//
//  SwiftUIView.swift
//  prtkt
//
//  Created by Rushil Madhu on 9/10/24.
//

import SwiftUI
import MapKit

struct KontentView: View {
    var body: some View {
        Map {
            Marker("San Francisco City Hall", coordinate: CLLocationCoordinate2D(latitude: 38.9899, longitude: -76.9380))
                .tint(.orange)
            Marker("San Francisco Public Library", coordinate: CLLocationCoordinate2D(latitude: 40, longitude: -77))
                .tint(.blue)
            Annotation("Diller Civic Center Playground", coordinate: CLLocationCoordinate2D(latitude: 38.9899, longitude: -76.9380)) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.yellow)
                    Text("🛝")
                        .padding(5)
                }
            }
        }
        .mapControlVisibility(.hidden)
    }
}
#Preview {
    KontentView()
}
