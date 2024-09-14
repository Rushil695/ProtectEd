//
//  Models.swift
//  prtkt
//
//  Created by Rushil Madhu on 9/13/24.
//

import MapKit
import Foundation

struct Rooms: Identifiable {
    let id = UUID()
    var name: String
    var coordinates: [CLLocationCoordinate2D]
    var detected = false
    var centerCoordinate: CLLocationCoordinate2D {
           let latitude = coordinates.map { $0.latitude }.reduce(0, +) / Double(coordinates.count)
           let longitude = coordinates.map { $0.longitude }.reduce(0, +) / Double(coordinates.count)
           return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
       }
}

struct Exits: Identifiable {
    let id = UUID()
    let name: String
    let coordinates: [CLLocationCoordinate2D]
    var highlighted = false
    
    var centerCoordinate: CLLocationCoordinate2D {
           let latitude = coordinates.map { $0.latitude }.reduce(0, +) / Double(coordinates.count)
           let longitude = coordinates.map { $0.longitude }.reduce(0, +) / Double(coordinates.count)
           return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
       }
}

enum GHError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

struct ShooterStatus: Codable {
    var room: String
    var detected: Bool
}
