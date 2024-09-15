import SwiftUI
import MapKit
import Foundation

struct CardView: View {
    @Binding var detection : String
    @EnvironmentObject var audiovm : AudioClassifier
    @Binding var position : MapCameraPosition
    @Binding var room: String
    @Binding var time: String
    
    var body: some View {
        if detection == ""  {
            GeometryReader { proxy in
                VStack {
                    Button(action: {
                        audiovm.start()
                    }, label: {
                        Text("YOU ARE SAFE")
                            .font(.title)
                            .padding(.top, 17.0)
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .bold()
                        
                    })
                    RoundedRectangle(cornerRadius: 25.0)
                        .frame(width: 380, height: 3)
                        .lineLimit(1)
                        .padding(.bottom, 20)
                        .foregroundStyle(.white)

                    HStack {
                        
                        Button(action: {
                            withAnimation {
                                // Goodwin: 37.232537, 80.425654
                                // New classrom: 37.229204, 80.426814
                                position = .camera(
                                    .init(centerCoordinate: CLLocationCoordinate2D(latitude: 37.2291, longitude: -80.42699), distance: 380)
                                )
                            // Goodwin:   position =.camera(.init(centerCoordinate: CLLocationCoordinate2D(latitude: 37.232537, longitude: -80.425654), distance: 380))
                                
                            // NEw classroom :   position =.camera(.init(centerCoordinate: CLLocationCoordinate2D(latitude: 37.229204, longitude: -80.426814), distance: 380))
                            }
                        }) {
                            Image("location")
                                .resizable()
                                .frame(width: 90, height: 90)
                        }
                        .padding([.bottom, .trailing], 50)
                        
                        VStack {
                            Text("Current Room : ")
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .font(.title2)
                                .bold()
                                .padding(.top, -45.0)
                                .padding(.bottom, 34.0)
                            Text(room)
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .font(.title2)
                                .padding(.top, -45.0)
                        }
                    }
                    HStack {
                        Text("Your next class: " + room)
                            .font(.custom("Extra", size: 20))
                            .foregroundStyle(.white)
                            .padding(.leading, 50)
                            .padding(.top)
                            .bold()
                        Button(action: {}, label: {
                            Image(systemName: "arrow.forward").foregroundStyle(.main)
                                .imageScale(.medium).padding(.trailing)
                        })
                        
                    }
                    .padding([.leading, .bottom, .trailing])
                    .padding(.top, -57.0)
                }
                .background(RoundedRectangle(cornerRadius: 30)).foregroundStyle(.main)
                .frame(width: proxy.size.width, height: proxy.size.height / 0.6)
            }
        } else {
            GeometryReader { proxy in
                VStack {
                    Text("DANGER:")
                        .font(.title)
                        .padding(.top, 17.0)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .bold()
                    Text("WEAPON DETECTED")
                        .foregroundStyle(.white)
                        .font(.title2)
                        .lineLimit(2)
                        .bold()
                    RoundedRectangle(cornerRadius: 25.0)
                        .frame(width: 380, height: 3)
                        .lineLimit(1)
                        .padding(.bottom, 50)
                        .foregroundStyle(.white)
                    HStack {
                        Button(action: {
                            withAnimation {
                                position = .camera(
                                    .init(centerCoordinate: CLLocationCoordinate2D(latitude: 37.23125, longitude: -80.42744), distance: 380)
                                )
                            }
                        }) {
                            Image("exit1").resizable()
                                .frame(width: 120, height: 80)
                        }
                        .padding()

                        VStack {
                            Text("Follow map to exit")
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .font(.title2)
                                .bold()
                                .padding(.top, 5)
                                .padding(.bottom, 10)
                            
                            HStack {
                                Text("Source:  \(detection)")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                    .bold()
                                
                            }
                            Text("Time: " + time)
                                .font(.title3)
                                .foregroundStyle(.white)
                        }
                    }
                    .padding([.leading, .bottom, .trailing])
                    .padding(.top, -57.0)
                }
                .background(RoundedRectangle(cornerRadius: 30)).foregroundStyle(.red)
                .frame(width: proxy.size.width, height: proxy.size.height / 0.6)
            }
        }
    }
}

#Preview {
    CardView(detection: .constant("audio"), position: .constant(.camera(
        .init(centerCoordinate: CLLocationCoordinate2D(latitude: 37.23125, longitude: -80.42744), distance: 380))), room: .constant("CMSC216"), time:.constant("HH:MM:ss"))
}
