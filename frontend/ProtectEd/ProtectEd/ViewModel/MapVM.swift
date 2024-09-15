// MapVM.swift

import Foundation
import MapKit
import CoreLocation

class MapVM: ObservableObject {
    @Published var shooter: ShooterStatus = ShooterStatus(room_number: "XXX", event_time: "", incident_source: "Audio", message: "")
    @Published var timer: Timer?
    @Published var shooterdetection = ""
    var locationManager = LocationManager()
    var ngronk = "https://5ddb-2607-b400-26-0-8477-7abe-92b7-b1dd.ngrok-free.app"
    
    
    
    
    
    @Published var userLocation = CLLocationCoordinate2D(latitude: 37.23186, longitude: 80.42737)

    @Published var rooms: [Rooms] = [
        Rooms(name: "DND101", coordinates: [
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
            detected: false)
    ]
    //put the closest exits first
    @Published var exits: [Exits] = [
        Exits(name: "Main", coordinates:
            CLLocationCoordinate2D(latitude: 37.23160, longitude: -80.42738),
            highlighted: false),
        Exits(name: "1", coordinates:
            CLLocationCoordinate2D(latitude: 37.23124, longitude: -80.42745),
            highlighted: false)
    ]
    
    @Published var regularPoints: [RegularPoint] = [
            RegularPoint(coordinate: CLLocationCoordinate2D(latitude: 37.23190, longitude: -80.42745)),
            RegularPoint(coordinate: CLLocationCoordinate2D(latitude: 37.2321, longitude: -80.42740))]
    
    @Published var perpetratorLocation: CLLocationCoordinate2D?
    
    //put the user location adn regularpoints and exits
    @Published var shortestPath: [CLLocationCoordinate2D] = []
    
    
    
    
    // Dijkstra's Algorithm with avoidance
    func dijkstra(source: Node, destination: Node, graph: [Node], perpetratorLocation: CLLocationCoordinate2D, avoidanceRadius: Double) -> [Node]? {
        print("Starting Dijkstra's algorithm.")
        var distances = [Node: Double]()
        var previousNodes = [Node: Node]()
        var unvisited = Set(graph)
        
        // Initialize distances
        for node in graph {
            distances[node] = Double.infinity
        }
        distances[source] = 0.0
        print("Initialized distances.")
        
        // Main Dijkstra Loop
        while !unvisited.isEmpty {
            // Find the node with the smallest distance
            guard let currentNode = unvisited.min(by: { distances[$0, default: Double.infinity] < distances[$1, default: Double.infinity] }) else {
                print("No reachable remaining nodes.")
                break
            }
            unvisited.remove(currentNode)
            print("Visiting node: \(currentNode.name)")
            
            // Stop if we've reached the destination
            if currentNode == destination {
                print("dijkstra: Destination node reached.")
                break
            }
            
            // Update distances for each neighbor
            for (neighbor, baseDistance) in currentNode.neighbors {
                if !unvisited.contains(neighbor) { continue }
                
                let alt = distances[currentNode]! + baseDistance
                print("alt: \(alt)")
                
                if alt < distances[neighbor, default: Double.infinity] {
                    distances[neighbor] = alt
                    previousNodes[neighbor] = currentNode
                    print("Updated distance for node \(neighbor.name): \(alt) meters")
                }
            }
        }
        
        // Reconstruct the shortest path
        var path: [Node] = []
        
        // We should start by adding the destination node to the path
        var currentNode: Node? = destination
        
        while let node = currentNode {
            path.insert(node, at: 0)  // Insert at the beginning to construct the path in the correct order
            currentNode = previousNodes[node]  // Move to the previous node in the path
        }
        
        // Ensure the destination node was added (in case it was not reachable)
        if path.isEmpty || path.first != source {
            print(" dijkstra: No path could be reconstructed.")
            return nil
        }
        
        print("Path reconstructed: \(path.map { $0.name })")
        return path
    }
    
    func addpoints() {
        DispatchQueue.main.async {
            self.shortestPath.append(contentsOf: [ self.rooms.first!.centerCoordinate,
                    CLLocationCoordinate2D(latitude: 37.23190, longitude: -80.42745),
                    CLLocationCoordinate2D(latitude: 37.23190, longitude: -80.42690),
                                                   self.exits.first!.coordinates])
            }
    }
    // setupGraph
    
    // Check both user and perpetrator locations before calculating the path
    func checkAndCalculatePath() {
        if let perpetratorLocation = self.perpetratorLocation {
            print("User location: \(userLocation)")
            print("Perpetrator location: \(perpetratorLocation)")
            
            // Call the path calculation function if both locations are available
            calculateShortestPath(userLocation: userLocation, perpetratorLocation: perpetratorLocation)
        } else {
            print("Either userLocation or perpetratorLocation is missing.")
        }
    }
    
    func calculateShortestPath(userLocation: CLLocationCoordinate2D, perpetratorLocation: CLLocationCoordinate2D) {
        print("Calculating shortest path from userLocation: \(userLocation) to perpetratorLocation: \(perpetratorLocation)")
        
        let graph = setupGraph(rooms: rooms, exits: exits, regularPoints: regularPoints, perpetratorLocation: perpetratorLocation)
        print("Graph setup completed with \(graph.count) nodes.")
        
        // Create a user node
        var userNode = Node(name: "User", coordinate: userLocation)
        
        // Find the nearest exit node
        guard let nearestExit = exits.min(by: {
            userNode.distance(to: Node(name: $0.name, coordinate: $0.coordinates)) <
            userNode.distance(to: Node(name: $1.name, coordinate: $1.coordinates))
        }) else {
            print("No exits found.")
            return
        }
        let exitNode = Node(name: nearestExit.name, coordinate: nearestExit.coordinates)
        print("Nearest exit found: \(exitNode.name) at \(exitNode.coordinate)")
        
        // Add the user node to the graph
        var extendedGraph = graph
        extendedGraph.append(userNode)
        for node in graph {
            let distance = userNode.distance(to: node)
            userNode.neighbors[node] = distance
        }
        print("User node added to the graph.")
        
        // Run Dijkstra's algorithm to find the shortest path
        if let path = dijkstra(source: userNode, destination: exitNode, graph: extendedGraph, perpetratorLocation: perpetratorLocation, avoidanceRadius: 10.0) {
            print("calculateShortestPath: Shortest path found with \(path.count) nodes: \(path.map { $0.name })")
            DispatchQueue.main.async {
                self.shortestPath = path.map { $0.coordinate }
                print("Updated shortest path with coordinates: \(self.shortestPath)")
            }
        } else {
            print("No path found.")
        }
    }

    
    func setupGraph(rooms: [Rooms], exits: [Exits], regularPoints: [RegularPoint], perpetratorLocation: CLLocationCoordinate2D) -> [Node] {
        var graph: [Node] = []
        
        // Step 1: Create nodes for rooms
        let roomNodes = rooms.map { room -> Node in
            var node = Node(name: room.name, coordinate: room.centerCoordinate)
            return node
        }
        
        // Step 2: Create nodes for exits
        let exitNodes = exits.map { exit -> Node in
            var node = Node(name: exit.name, coordinate: exit.coordinates)
            return node
        }
        
        // Step 3: Create nodes for regular points (hallways, intersections, etc.)
        let regularNodes = regularPoints.map { point -> Node in
            var node = Node(name: "Point \(point.coordinate.latitude), \(point.coordinate.longitude)", coordinate: point.coordinate)
            return node
        }
        
        // Combine all nodes into one graph
        graph = roomNodes + exitNodes + regularNodes
        
        // Step 4: Calculate neighbors and distances
        for i in 0..<graph.count {
            for j in 0..<graph.count where i != j {
                let distance = graph[i].distance(to: graph[j])
                graph[i].neighbors[graph[j]] = distance
            }
        }
        
        // Step 5: Add avoidance logic for nodes near the perpetrator's location
        let avoidanceRadius = 50.0 // meters
        for i in 0..<graph.count {
            let distanceToPerpetrator = graph[i].distance(to: Node(name: "Perpetrator", coordinate: perpetratorLocation))
            if distanceToPerpetrator < avoidanceRadius {
                // Increase the distance (penalty) for nodes near the perpetrator
                for j in 0..<graph.count where i != j {
                    graph[i].neighbors[graph[j]] = (graph[i].neighbors[graph[j]] ?? 0) + 1000.0 // Add a large penalty
                }
            }
        }
        
        return graph
    }


    
    
    func setPerpetratorLocation(to location: CLLocationCoordinate2D) {
        DispatchQueue.main.async {
            self.perpetratorLocation = location
            print("Perpetrator location set to \(location)")
            self.checkAndCalculatePath()
        }
    }

    
    

// MARK : Backend Requests
    // Updates the room's detected variable as true and sends the log to the backend
    func shooterDetected(roomnumber: String) async {
        DispatchQueue.main.async {
            if let index = self.rooms.firstIndex(where: { $0.name == roomnumber }) {
                self.rooms[index].detected = true
                print("Room \(roomnumber) detected status set to true.")
                self.perpetratorLocation = self.rooms[index].centerCoordinate
                print("Perpetrator location set to \(self.perpetratorLocation!)")
            } else {
                print("Room with name \(roomnumber) not found in rooms array.")
            }
        }
        guard let url = URL(string: ngronk + "/audio-incident-log/") else {
            print("Invalid URL")
            return
        }
        
        // Get current time in HH:mm:ss format
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
        print(response)
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(ShooterStatus.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
    
    // Sends the GET requests every second
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
    
    // If a shooter is detected, mark the room as detected
    func updateRoomDetectionStatus(with status: ShooterStatus) {
        if status.message != "No incidents available" {
            if let index = rooms.firstIndex(where: { $0.name == status.room_number }) {
                self.shooterdetection = status.incident_source
                rooms[index].detected = true
                self.perpetratorLocation = rooms[index].centerCoordinate
                self.stopPolling()
            }
        }
    }
    
    func stopPolling() {
        timer?.invalidate()
    }
}


// MARK : Location Manager
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
