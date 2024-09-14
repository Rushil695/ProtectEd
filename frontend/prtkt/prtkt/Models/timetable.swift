//
//  timetable.swift
//  prtkt
//
//  Created by Tanya Grover on 9/7/24.
//

import Foundation
import MapKit
import Foundation


struct Class: Identifiable {
    let id = UUID()
    var name: String
    var startTime: Date
    var endTime: Date
    var room: Rooms
}

enum Weekday: String, CaseIterable, Identifiable {
    case monday, tuesday, wednesday, thursday, friday

    var id: String { self.rawValue }
}

struct Timetable {
    var schedule: [Weekday: [Class]] = [:]
    
    init() {
        Weekday.allCases.forEach { day in
            schedule[day] = []
        }
    }
}
