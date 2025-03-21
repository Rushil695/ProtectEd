//
//  Djikstras.swift
//  ProtectEd
//
//  Created by Rushil Madhu on 9/15/24.
//
import Foundation
import MapKit

// Step 1: Define a structure to represent a graph node (room or exit)
struct Node: Hashable {
    var name: String
    var coordinate: CLLocationCoordinate2D
    var neighbors: [Node: Double] = [:] // Stores neighboring nodes and their distances
    
    // Calculate distance between two nodes
    func distance(to node: Node) -> Double {
        let currentLocation = CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        let destinationLocation = CLLocation(latitude: node.coordinate.latitude, longitude: node.coordinate.longitude)
        return currentLocation.distance(from: destinationLocation) // Distance in meters
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.name == rhs.name &&
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

// Step 2: Dijkstra's Algorithm with Avoidance of Perpetrator
func dijkstra(source: Node, destination: Node, graph: [Node], perpetratorLocation: CLLocationCoordinate2D, avoidanceRadius: Double) -> [Node]? {
    var distances = [Node: Double]()
    var previousNodes = [Node: Node]()
    var unvisited = Set(graph)
    
    // Initialize distances
    for node in graph {
        distances[node] = Double.infinity
    }
    distances[source] = 0.0
    
    // Main Dijkstra Loop
    while !unvisited.isEmpty {
        // Find the node with the smallest distance
        let currentNode = unvisited.min(by: { distances[$0, default: Double.infinity] < distances[$1, default: Double.infinity] })!
        unvisited.remove(currentNode)
        
        // Stop if we've reached the destination
        if currentNode == destination {
            break
        }
        
        // Update distances for each neighbor
        for (neighbor, baseDistance) in currentNode.neighbors {
            // Penalize nodes that are within the avoidance radius of the perpetrator
            let distanceToPerpetrator = neighbor.distance(to: Node(name: "Perpetrator", coordinate: perpetratorLocation))
            let penalty = distanceToPerpetrator < avoidanceRadius ? 1000.0 : 0.0  // Higher penalty for nodes near perpetrator
            let alt = distances[currentNode]! + baseDistance + penalty
            
            if alt < distances[neighbor, default: Double.infinity] {
                distances[neighbor] = alt
                previousNodes[neighbor] = currentNode
            }
        }
    }
    
    // Reconstruct the shortest path
    var path: [Node] = []
    var currentNode: Node? = destination
    while currentNode != nil {
        path.insert(currentNode!, at: 0)
        currentNode = previousNodes[currentNode!]
    }
    
    return path.isEmpty ? nil : path
}

// Step 3: Set up your graph with rooms and exits, similar to before
// The setupGraph function
func setupGraph(rooms: [Rooms], exits: [Exits], regularPoints: [CLLocationCoordinate2D], perpetratorLocation: CLLocationCoordinate2D) -> [Node] {
    
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
        var node = Node(name: "Point \(point.latitude), \(point.longitude)", coordinate: point)
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
    let avoidanceRadius = 10.0 // meters
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



//let graph = setupGraph()
//let room1 = graph.first(where: { $0.name == "Room1" })!
//let perpetratorLocation = CLLocationCoordinate2D(latitude: 37.23185, longitude: -80.42735) // Example location of the perpetrator
//let avoidanceRadius = 50.0 // Avoid nodes within 50 meters of the perpetrator
//
//if let path = findClosestExit(from: room1, graph: graph, perpetratorLocation: perpetratorLocation, avoidanceRadius: avoidanceRadius) {
//    print("Shortest path from \(room1.name) to the nearest exit avoiding the perpetrator: \(path.map { $0.name })")
//} else {
//    print("No path found.")
//}
