import SwiftUI
import MapKit

struct MapView: View {
    var timetable: Timetable
    @StateObject var mapvm = MapVM()
    @State private var position: MapCameraPosition = .camera(
        .init(centerCoordinate: CLLocationCoordinate2D(latitude: 37.23125, longitude: -80.42744), distance: 380))
    @StateObject var audiovm = AudioClassifier()
    
    func getCurrentClass() -> Class? {
        let currentWeekday: Weekday = .monday // Forcing it to Monday for testing purposes

        guard let classesToday = timetable.schedule[currentWeekday] else {
            print("No classes found for \(currentWeekday)")
            return nil
        }

        let currentDate = Date()
        let calendar = Calendar.current
        let nowComponents = calendar.dateComponents([.hour, .minute], from: currentDate)
        guard let nowHour = nowComponents.hour, let nowMinute = nowComponents.minute else {
            print("Could not get current time components")
            return nil
        }
        let nowTotalMinutes = nowHour * 60 + nowMinute

        for (index, currentClass) in classesToday.enumerated() {
            let startComponents = calendar.dateComponents([.hour, .minute], from: currentClass.startTime)
            guard let startHour = startComponents.hour, let startMinute = startComponents.minute else {
                continue
            }
            let startTotalMinutes = startHour * 60 + startMinute

            // If this is the last class of the day, treat it as spanning to the end of the day
            if index == classesToday.count - 1 {
                if nowTotalMinutes >= startTotalMinutes {
                    print("Current class found: \(currentClass.name)")
                    return currentClass
                }
            } else {
                // Get the next class to treat its start as the end of the current class
                let nextClass = classesToday[index + 1]
                let nextStartComponents = calendar.dateComponents([.hour, .minute], from: nextClass.startTime)
                guard let nextStartHour = nextStartComponents.hour, let nextStartMinute = nextStartComponents.minute else {
                    continue
                }
                let nextStartTotalMinutes = nextStartHour * 60 + nextStartMinute

                if nowTotalMinutes >= startTotalMinutes && nowTotalMinutes < nextStartTotalMinutes {
                    print("Current class found: \(currentClass.name)")
                    return currentClass
                }
            }
        }
        
        print("No current class matches the current time")
        return nil
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
                        
                                .foregroundStyle(.white)
                                .background(.red)
                        }
                    }
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
                        
                        CardView(detection: $mapvm.shooterdetection, position: $position, room: .constant(currentClass.room.name))
                            .environmentObject(audiovm)
                            .opacity(0.9)
                    }
                } else {
                    VStack {
                        Spacer()
                        CardView(detection: $mapvm.shooterdetection, position: $position, room: .constant("No Class"))
                            .environmentObject(audiovm)
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
                if audiovm.detectedSound == "Guns" && audiovm.confidence > 0.8 {
                    mapvm.stopPolling()
                    mapvm.shooterdetection = "Audio"
                    
                    audiovm.stopListening()
                    Task {
                        await mapvm.shooterDetected(roomnumber: getCurrentClass()?.room.name ?? "x")}
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
    let sampleClass1 = Class(name: "CS101", startTime: startTime1, room: sampleRoom1)
    
    let startTime2 = calendar.date(byAdding: .hour, value: -2, to: currentDate)!
    let endTime2 = calendar.date(byAdding: .hour, value: -1, to: currentDate)!
    let sampleClass2 = Class(name: "MATH201", startTime: startTime2, room: sampleRoom2)
    
    let startTime3 = calendar.date(byAdding: .hour, value: 1, to: currentDate)!
    let endTime3 = calendar.date(byAdding: .hour, value: 2, to: currentDate)!
    let sampleClass3 = Class(name: "ENG202", startTime: startTime3, room: sampleRoom1)
    
    var sampleTimetable = Timetable()
    
    let currentWeekday: Weekday = .monday
    sampleTimetable.schedule[currentWeekday] = [sampleClass1, sampleClass2, sampleClass3]
    
    return MapView(timetable: sampleTimetable)
}
