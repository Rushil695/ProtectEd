//
//  MapView.swift
//  prtkt
//
//  Created by Rushil Madhu on 9/10/24.
//

import SwiftUI
import MapKit

// Define a common enum to handle both Room and Exit
enum MapItem: Identifiable {
    case room(Room)
    case exit(Exit)
    
    var id: UUID {
        switch self {
        case .room(let room):
            return room.id
        case .exit(let exit):
            return exit.id
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .room(let room):
            return room.coordinate
        case .exit(let exit):
            return exit.coordinate
        }
    }
    
    var title: String {
        switch self {
        case .room(let room):
            return room.name
        case .exit(let exit):
            return exit.name
        }
    }
}

struct Room: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct Exit: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @StateObject var mapvm = MapVM()

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.2320, longitude: -80.42695),
        span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    )
    
    let rooms = [
        Room(name: "Room 101", coordinate: CLLocationCoordinate2D(latitude: 38.9897, longitude: -76.9378)),
        Room(name: "Room 102", coordinate: CLLocationCoordinate2D(latitude: 38.9895, longitude: -76.9379)),
    ]
    
    let exits = [
        Exit(name: "Exit A", coordinate: CLLocationCoordinate2D(latitude: 38.9899, longitude: -76.9380)),
        Exit(name: "Exit B", coordinate: CLLocationCoordinate2D(latitude: 38.9894, longitude: -76.9377)),
    ]
    
    @State private var shooterLocation: CLLocationCoordinate2D? = nil
    var body: some View {
        // Combine rooms and exits into one array using MapItem enum
        let mapItems: [MapItem] = rooms.map { MapItem.room($0) } + exits.map { MapItem.exit($0) }
        
        ZStack {
            
            // Define bounds for the map using MapCameraBounds
            let mapBounds = MapCameraBounds(centerCoordinateBounds: region, minimumDistance: 380, maximumDistance: 400)
            
            // Map with bounds, interactionModes, and namespace
            Map(bounds: mapBounds, interactionModes: [.zoom]) {
            }
            .mapStyle(.hybrid)
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            region = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 37.2320, longitude: -80.42695),
                                span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
                            )
                        }
                               , label: {
                            Image(systemName: "location.circle.fill")
                                .font(.title)
                            
                            
                        })
                        .frame(width: 60, height: 100)
                        .padding(.leading, 26.0)
                        Spacer()
                        Text(mapvm.detected ? "Shooter Detected!" : "Safe")
                            .font(.custom("TYPOGRAPH PRO Light", size: 22))
                            .frame(width: 180, height: 40)
                            .padding()
                            .background(mapvm.detected ? Color.red : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(18)
                            .padding(.trailing, 62.0)
                        Spacer()
                    }
                }
            }
        }
    }
    

#Preview {
    MapView()
}
    
