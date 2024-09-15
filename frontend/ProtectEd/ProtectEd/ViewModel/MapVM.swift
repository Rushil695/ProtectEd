import Foundation
import MapKit
import CoreLocation

class MapVM: ObservableObject {
    @Published var shooter: ShooterStatus = ShooterStatus(room_number: "XXX", event_time: "", incident_source: "Audio", message: "")
    @Published var timer: Timer?
    @Published var shooterdetection = ""
    @Published var userLocation: CLLocationCoordinate2D?
    var locationManager = LocationManager()
    @Published var rooms: [Rooms] = [Rooms(name: "DND101", coordinates: [
        CLLocationCoordinate2D(latitude: 37.23193, longitude: -80.42738),
        CLLocationCoordinate2D(latitude: 37.23184, longitude: -80.42727),
        CLLocationCoordinate2D(latitude: 37.23180, longitude: -80.42737),
        CLLocationCoordinate2D(latitude: 37.23187, longitude: -80.42745)],
                                           detected: false),
                                            Rooms(name: "DND102", coordinates: [
                                            CLLocationCoordinate2D(latitude: 37.23182, longitude: -80.42752),
                                            CLLocationCoordinate2D(latitude: 37.23172, longitude: -80.42739),
                                            CLLocationCoordinate2D(latitude: 37.23177, longitude: -80.42759),
                                            CLLocationCoordinate2D(latitude: 37.23173, longitude: -80.42743)],
                                                    
                                                  detected: false)]
    @Published var exits = [Exits(name: "Main", coordinates:
                                    CLLocationCoordinate2D(latitude: 37.23160, longitude: -80.42738),
                                  highlighted: false)]
    
    var ngronk = "https://bb45-2607-b400-26-0-8477-7abe-92b7-b1dd.ngrok-free.app"
    
    
    
    //updates the room's detected variable as true and sends the log to the backend
    func shooterDetected(roomnumber: String) async {
        DispatchQueue.main.async {
            if let index = self.rooms.firstIndex(where: { $0.name == roomnumber }) {
                self.rooms[index].detected = true
                print("Room \(roomnumber) detected status set to true.")
            } else {
                print("Room with name \(roomnumber) not found in rooms array.")
            }
        }
        guard let url = URL(string: ngronk + "/audio-incident-log/") else {
            print("Invalid URL")
            return
        }
        
        // Get current time in HH:MM:SS format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let eventTime = dateFormatter.string(from: Date())
        
        // Prepare the request body
        let requestBody: [String: String] = [
            "room_number": roomnumber,
            "event_time": eventTime,
            "incident_source": "Audio"
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Shooter detected event logged successfully.")
                } else {
                    print("Server returned an error: \(httpResponse.statusCode)")
                }
            }
        } catch {
            print("Error sending shooter detected request: \(error)")
        }
        
    }
    
    
    
    
    
    
    func sendGetRequest1second() async throws -> ShooterStatus {
        guard let url = URL(string: ngronk + "/report-event/") else {
            throw GHError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHError.invalidResponse
        }
        print(data)
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(ShooterStatus.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
    
    //sends the post requests every second
    func startPolling() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task {
                do {
                    let shooterStatus = try await self.sendGetRequest1second()
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
    
    //if a shooter is detected then for that room make the detected true
    func updateRoomDetectionStatus(with status: ShooterStatus) {
        if status.message != "No incidents available"{
            if let index = rooms.firstIndex(where: { $0.name == status.room_number }) {
                self.shooterdetection = status.incident_source
                rooms[index].detected = true
                self.stopPolling()
            }
        }
    }
    
    
    
    func stopPolling() {
        timer?.invalidate()
    }
}

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
