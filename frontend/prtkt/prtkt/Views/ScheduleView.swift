import SwiftUI

import SwiftUI

struct ScheduleView: View {
    @State private var timetable = Timetable()
    let defaultRoom = Rooms(name: "Unknown", coordinates: [])

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Enter Your Schedule")
                        .font(.largeTitle)
                        .bold()
                        .padding()

                    ForEach(Weekday.allCases) { day in
                        DayScheduleView(
                            classes: Binding(
                                get: { timetable.schedule[day] ?? [] },
                                set: { timetable.schedule[day] = $0 }
                            ),
                            dayName: day.rawValue.capitalized,
                            defaultRoom: defaultRoom
                        )
                    }

                    NavigationLink(destination: MapView(timetable: timetable)) {
                        Text("Go to Map")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .padding()
            }
            .navigationBarTitle("Schedule", displayMode: .inline)
        }
    }
}
#Preview {
    ScheduleView()
}


//@Binding var classes: [Class]
//var dayName: String
//var defaultRoom: Rooms
//
//var body: some View {
//    VStack(alignment: .leading) {
//        HStack {
//            Text(dayName)
//                .font(.headline)
//                .padding()
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(10)
//            
//            Spacer()
//            
//            Button(action: {
//                classes.append(Class(name: "", startTime: Date(), endTime: Date(), room: defaultRoom))
//            }) {
//                Image(systemName: "plus.circle.fill")
//                    .resizable()
//                    .frame(width: 25, height: 25)
//                    .foregroundColor(.blue)
//            }
//        }
//        
//        ForEach(classes) { classs in
//                HStack {
//                    TextField("Class Name", text: $classs.name)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .frame(width: 100)
//
//                    DatePicker("", selection: $classs.startTime, displayedComponents: .hourAndMinute)
//                        .labelsHidden()
//
//                    DatePicker("", selection: $classs.endTime, displayedComponents: .hourAndMinute)
//                        .labelsHidden()
//
//                    TextField("Room", text: $classs.room.name)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .frame(width: 80)
//
//                    Button(action: {
//                        if let index = classes.firstIndex(where: { $0.id == classes.id }) {
//                            classes.remove(at: index)
//                        }
//                    }) {
//                        Image(systemName: "minus.circle.fill")
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(.red)
//                    }
//                }
//        }
//    }
//    .padding()
//    .background(Color.white.opacity(0.9))
//    .cornerRadius(10)
//    .shadow(radius: 5)
//    .padding(.bottom)
//}
//}
//
//struct ScheduleView: View {
//@State private var timetable = Timetable()
//let defaultRoom = Rooms(name: "Unknown", coordinates: [])
//
//var body: some View {
//    NavigationView {
//        ScrollView {
//            VStack {
//                Text("Enter Your Schedule")
//                    .font(.largeTitle)
//                    .bold()
//                    .padding()
//                
//                ForEach(Weekday.allCases) { day in
//                    DayScheduleView(classes: Binding(
//                        get: { timetable.schedule[day] ?? [] },
//                        set: { timetable.schedule[day] = $0 }
//                    ), dayName: day.displayName, defaultRoom: defaultRoom)
//                }
//                
//                // Navigation button to MapView
//                NavigationLink(destination: MapView(timetable: timetable)) {
//                    Text("Go to Map")
//                        .font(.headline)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding()
//            }
//            .padding()
//        }
//        .navigationBarTitle("Schedule", displayMode: .inline)
//    }
//}
