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
                    .frame(width: 300, height: 35)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(15)
                    .foregroundColor(.black)
                    .padding(.leading, 30)
                    .padding(.bottom, 10)

               Button(action: {
                    classes.append(Class(name: "", startTime: Date(), endTime: Date(), room: defaultRoom))
                    
               }){
                    Image(systemName: "plus.circle.fill")
                        
                        .resizable()
                        .frame(width: 25, height: 25)
                        .cornerRadius(15)
                    
                    }
               
                .background(.white)
                .shadow(radius:2)
                .frame(width: 25, height: 25)
                .cornerRadius(15)
               
            }

            ForEach($classes) { $classItem in
                HStack {
                    
                    TextField("Class Name", text: $classItem.name)
                        .padding()
                        .frame(width: 130, height: 35)
                        .background(Color.gray.opacity(0.4))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    
                    TextField("Room", text: $classItem.room.name)
                        .frame(width: 100, height: 35)
                        .background(Color.gray.opacity(0.4))
                        .foregroundColor(.black)
                        .cornerRadius(10)
               
                    DatePicker("", selection: $classItem.startTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()

                    
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
