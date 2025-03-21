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
                            .frame(width: 400, height: 40)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .bold()
                            .padding(.top, 50)
                            .padding(.bottom, 80)
                        
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
    
                        .padding(.bottom, 10)
                        NavigationLink(destination: MapView(timetable: timetable)) {
                            Text("Go to Map")
                                .font(.title2)
                                .frame(width: 200 , height: 60)
                                .background(Color(red: 0.0, green: 0.6, blue: 0.0))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            
                        }.navigationBarBackButtonHidden()
                        .padding(.bottom, 40)
                    
                    }
                    
            }
        }.background(Color.main)
    }
}
#Preview {
    ScheduleView()
}


