import Foundation
import MapKit
import CoreLocation

struct Location: Equatable {
    let coordinate: CLLocationCoordinate2D?
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        guard let lhsCoordinate = lhs.coordinate, let rhsCoordinate = rhs.coordinate else {
            return false
        }
        return lhsCoordinate.latitude == rhsCoordinate.latitude &&
               lhsCoordinate.longitude == rhsCoordinate.longitude
    }
}

class MapVM: ObservableObject {
    @Published var shooter: ShooterStatus = ShooterStatus(room: "CMSC216", detected: false)
    @Published var timer: Timer?
    @Published var userLocation: CLLocationCoordinate2D?
    var locationManager = LocationManager()
    @Published var rooms: [Rooms] = [
        Rooms(name: "102", coordinates: [
            CLLocationCoordinate2D(latitude: 37.23193, longitude: -80.42738),
            CLLocationCoordinate2D(latitude: 37.23184, longitude: -80.42727),
            CLLocationCoordinate2D(latitude: 37.23180, longitude: -80.42737),
            CLLocationCoordinate2D(latitude: 37.23187, longitude: -80.42745)],
              detected: true)]
    @Published var exits = [Exits(name: "Main", coordinates: [
        CLLocationCoordinate2D(latitude: 37.23193, longitude: -80.42738),
        CLLocationCoordinate2D(latitude: 37.23195, longitude: -80.42727),
        CLLocationCoordinate2D(latitude: 37.23196, longitude: -80.4274),
        CLLocationCoordinate2D(latitude: 37.23187, longitude: -80.42745)],
                          highlighted: false)]
    
    func startPolling() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task {
                do {
                    let shooterStatus = try await self.sendRequestToBackend()
                    DispatchQueue.main.async {
                        self.shooter = shooterStatus
                        self.updateRoomDetectionStatus(with: shooterStatus)
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func stopPolling() {
        timer?.invalidate()
    }
    
    func updateRoomDetectionStatus(with status: ShooterStatus) {
        if !status.detected {
            // Look for the room that matches the shooter status's room name
            if let index = rooms.firstIndex(where: { $0.name == status.room }) {
                // Update the detected value of that room to true
                rooms[index].detected = true
            }
        }
    }
    
    func sendRequestToBackend() async throws -> ShooterStatus {
        guard let url = URL(string: "https://your-backend-api.com/check_shooter_status") else {
            throw GHError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(ShooterStatus.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location = Location(coordinate: nil)  

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            DispatchQueue.main.async {
                self.location = Location(coordinate: location.coordinate)  // Update using Location struct
            }
        }
    }
}
