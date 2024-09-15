import SwiftUI

struct ScheduleView: View {
    @State private var timetable = Timetable()
    let defaultRoom = Rooms(name: "", coordinates: [])

    var body: some View {
        NavigationStack {
           
                ZStack {
                    Color.main.opacity(0.8).ignoresSafeArea()
                    
                    Circle()
                        .scale(1.9)
                        .foregroundColor(.white.opacity(0.3))
                    
                    Circle()
                        .scale(1.4)
                        .foregroundColor(.white.opacity(0.2))
                    
                    
                        
                    VStack(alignment: .center) {
                        Text("Enter Your Schedule")
                            .frame(width: 300, height: 40)
                            .font(.system(size: 32))
                            .fontWeight(.medium)
                            .shadow(radius: 5)
                            .foregroundColor(.black)
                            .bold()
                            .padding(.top, 45)
                            .padding(.bottom, 35)
                        
                        ScrollView {
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
                            .padding(.top, 50)
                        }
    
                        .padding(.bottom, 40)
                        NavigationLink(destination: MapView(timetable: timetable)) {
                            Text("Go to Map")
                                .font(.headline)
                                .frame(width: 100 , height: 30)
                                .background(Color.main)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            
                        }.navigationBarBackButtonHidden()
                        .padding(.bottom, 50)
                    
                    }
                    
            }
        }.background(Color.main)
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
