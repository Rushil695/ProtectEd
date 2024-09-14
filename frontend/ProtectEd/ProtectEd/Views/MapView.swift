import SwiftUI
import MapKit

struct MapView: View {
    var timetable: Timetable
    @StateObject var mapvm = MapVM()
    @State private var position: MapCameraPosition = .camera(
        .init(centerCoordinate: CLLocationCoordinate2D(latitude: 37.23125, longitude: -80.42744), distance: 380))
    @StateObject var audiovm = AudioClassifier()
    
    func getCurrentClass() -> Class? {
        // let currentDate = Date()
        // let calendar = Calendar.current
        // let weekdayIndex = calendar.component(.weekday, from: currentDate)
        // let weekdayMapping: [Int: Weekday] = [
        //     2: .monday,
        //     3: .tuesday,
        //     4: .wednesday,
        //     5: .thursday,
        //     6: .friday]
        // guard let currentWeekday = weekdayMapping[weekdayIndex],
        //       let classesToday = timetable.schedule[currentWeekday]
        // else {
        //     return nil
        // }

        // Always set the current weekday to Monday
        let currentWeekday: Weekday = .monday

        guard let classesToday = timetable.schedule[currentWeekday] else {
            return nil
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        return classesToday.first { currentClass in
            let startComponents = calendar.dateComponents([.hour, .minute], from: currentClass.startTime)
            let endComponents = calendar.dateComponents([.hour, .minute], from: currentClass.endTime)
            let nowComponents = calendar.dateComponents([.hour, .minute], from: currentDate)
            
            guard let startHour = startComponents.hour,
                  let startMinute = startComponents.minute,
                  let endHour = endComponents.hour,
                  let endMinute = endComponents.minute,
                  let nowHour = nowComponents.hour,
                  let nowMinute = nowComponents.minute else {
                return false
            }
            
            let startTotalMinutes = startHour * 60 + startMinute
            let endTotalMinutes = endHour * 60 + endMinute
            let nowTotalMinutes = nowHour * 60 + nowMinute
            
            return nowTotalMinutes >= startTotalMinutes && nowTotalMinutes <= endTotalMinutes
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Map(position: $position, interactionModes: [.all]) {
                    ForEach(mapvm.rooms) { room in
                        MapPolygon(coordinates: room.coordinates)
                            .foregroundStyle(room.detected ? .red : .main)
                        Annotation(room.name, coordinate: room.centerCoordinate) {
                            
                        }
                    }
                    ForEach(mapvm.exits) { exit in
                        Annotation("", coordinate: exit.coordinates) {
                            Image("exit")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                    UserAnnotation()
                    if let userLocation = mapvm.locationManager.location.coordinate {
                        Annotation("Your Location", coordinate: userLocation) {
                            Image(systemName: "location.north.fill")
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)

                if let currentClass = getCurrentClass() {
                    VStack {
                        Spacer()
                        CardView(detection: $mapvm.shooter.detected, position: $position, room: .constant(currentClass.room.name))
                            .opacity(0.9)
                    }
                } else {
                    VStack {
                        Spacer()
                        CardView(detection: $mapvm.shooter.detected, position: $position, room: .constant("No Class"))
                            .opacity(0.9)
                    }
                }
            }
            .onAppear {
                mapvm.startPolling()
            }
            .onDisappear {
                mapvm.stopPolling()
            }
            .onChange(of: audiovm.detectedSound) {
                if audiovm.detectedSound == "Gunshot" && audiovm.confidence > 0.7 {
                    mapvm.shooter.detected = true
                }
            }
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    // Create sample rooms with coordinates
    let sampleRoom1 = Rooms(name: "IAD100",
        coordinates: [
            CLLocationCoordinate2D(latitude: 37.23193, longitude: -80.42738),
            CLLocationCoordinate2D(latitude: 37.23184, longitude: -80.42727),
            CLLocationCoordinate2D(latitude: 37.23180, longitude: -80.42737),
            CLLocationCoordinate2D(latitude: 37.23187, longitude: -80.42745)])
    
    let sampleRoom2 = Rooms(
        name: "IAD200",
        coordinates: [
            CLLocationCoordinate2D(latitude: 37.23200, longitude: -80.42750),
            CLLocationCoordinate2D(latitude: 37.23195, longitude: -80.42740),
            CLLocationCoordinate2D(latitude: 37.23190, longitude: -80.42750),
            CLLocationCoordinate2D(latitude: 37.23195, longitude: -80.42760)])
    
    let currentDate = Date()
    let calendar = Calendar.current
    
    let startTime1 = calendar.date(byAdding: .minute, value: -30, to: currentDate)!
    let endTime1 = calendar.date(byAdding: .minute, value: 30, to: currentDate)!
    let sampleClass1 = Class(name: "CS101", startTime: startTime1, endTime: endTime1, room: sampleRoom1)
    
    let startTime2 = calendar.date(byAdding: .hour, value: -2, to: currentDate)!
    let endTime2 = calendar.date(byAdding: .hour, value: -1, to: currentDate)!
    let sampleClass2 = Class(name: "MATH201", startTime: startTime2, endTime: endTime2, room: sampleRoom2)
    
    let startTime3 = calendar.date(byAdding: .hour, value: 1, to: currentDate)!
    let endTime3 = calendar.date(byAdding: .hour, value: 2, to: currentDate)!
    let sampleClass3 = Class(name: "ENG202", startTime: startTime3, endTime: endTime3, room: sampleRoom1)
    
    var sampleTimetable = Timetable()
    
    let currentWeekday: Weekday = .monday
    sampleTimetable.schedule[currentWeekday] = [sampleClass1, sampleClass2, sampleClass3]
    
    return MapView(timetable: sampleTimetable)
}
