//
//  DaySchedule View.swift
//  prtkt
//
//  Created by Rushil Madhu on 9/14/24.
//

import SwiftUI
import MapKit

struct DayScheduleView: View {
    @Binding var classes: [Class]
    var dayName: String
    var defaultRoom: Rooms

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(dayName)
                    .font(.headline)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                Spacer()

                Button(action: {
                    classes.append(Class(name: "", startTime: Date(), endTime: Date(), room: defaultRoom))
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.blue)
                }
            }

            ForEach($classes) { $classItem in
                HStack {
                    TextField("Class Name", text: $classItem.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)

                    DatePicker("", selection: $classItem.startTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()

                    DatePicker("", selection: $classItem.endTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()

                    TextField("Room", text: $classItem.room.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 80)

                    Button(action: {
                        if let index = classes.firstIndex(where: { $0.id == classItem.id }) {
                            classes.remove(at: index)
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.bottom)
    }
}

#Preview {
    // Sample Room
    let sampleRoom = Rooms(
        name: "Sample Room",
        coordinates: [
            CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        ]
    )
    
    // Sample Classes
    let sampleClasses: [Class] = [
        Class(
            name: "Math 101",
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600), // 1 hour later
            room: sampleRoom
        ),
        Class(
            name: "History 202",
            startTime: Date().addingTimeInterval(7200), // 2 hours later
            endTime: Date().addingTimeInterval(10800), // 3 hours later
            room: sampleRoom
        )
    ]
    
    return DayScheduleView(
        classes: .constant(sampleClasses),
        dayName: "Monday",
        defaultRoom: sampleRoom
    )
}
