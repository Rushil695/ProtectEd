//
//  TestView.swift
//  prtkt
//
//  Created by Rushil Madhu on 9/13/24.
//

import SwiftUI
import MapKit
import Foundation

struct CardView: View {
    @Binding var detection : String
    
    @Binding var position : MapCameraPosition
    @Binding var room: String
    
    var body: some View {
        if detection == ""  {
            GeometryReader { proxy in
                VStack {
                    Text(" YOU ARE SAFE")
                        .font(.title)
                        .padding(.top, 17.0)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .bold()
                    RoundedRectangle(cornerRadius: 25.0)
                        .frame(width: 380, height:3)
                        .lineLimit(1)
                        .padding(.bottom, 20)
                        .foregroundStyle(.white)
                    
                        .foregroundStyle(.white)
                    HStack {
                        
                        Button(action: {
                            withAnimation {
                                position = .camera(
                                    .init(centerCoordinate: CLLocationCoordinate2D(latitude: 37.23125, longitude: -80.42744), distance: 380)
                                )}})
                        {
                            Image("location")
                                .resizable()
                        }
                        .frame(width: 90, height: 90)
                        .padding(.bottom, 50)
                        
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
                            .bold()

                        Image(systemName: "arrow.forward").foregroundStyle(.main)
                            .imageScale(.medium).padding(.trailing)
                        
                    }
                    
                    .padding([.leading, .bottom, .trailing])
                    .padding(.top, -57.0)
                    
                }
                .background(RoundedRectangle(cornerRadius: 30)).foregroundStyle(.main)
                .frame(width: proxy.size.width, height: proxy.size.height / 0.6)
            }
        }
        else
        {
            GeometryReader { proxy in
                VStack {
                    Text("DANGER: WEAPON DETECTED")
                        .font(.title)
                        .padding(.top, 17.0)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .bold()
                    RoundedRectangle(cornerRadius: 25.0)
                        .frame(width: 380, height:3)
                        .lineLimit(1)
                        .padding(.bottom, 50)
                        .foregroundStyle(.white)
                    HStack {
                        
                        Button(action: {
                            withAnimation {
                                position = .camera(
                                    .init(centerCoordinate: CLLocationCoordinate2D(latitude: 37.23125, longitude: -80.42744), distance: 380)
                                )}})
                        {
                            Image("exit1").resizable()
                                
                        }
                        .frame(width: 90, height: 90)

                        .padding()
                        
                        VStack {
                            Text("Follow map to nearest exit")
                                .foregroundStyle(.white)
                                .lineLimit(2)
                                .font(.title2)
                                .bold()
                                .padding(.top, 5)
                                .padding(.bottom, 10)
                            
                            let status = ShooterStatus(room_number: "101", event_time: "12:03:45", incident_source: "Sensor", message: "All clear")
                            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, content: {
                                
                                Text("Audio detected at:")
                                    .font(.title3)
                                    
                                    .foregroundStyle(.white)
                                
                                Text(status.event_time.prefix(5))
                                    .font(.title3)
                                    .foregroundStyle(.white)
                                   
                            })
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
    CardView(detection: .constant(""), position: .constant(.camera(
        .init(centerCoordinate: CLLocationCoordinate2D(latitude: 37.23125, longitude: -80.42744), distance: 380))),room: .constant("CMSC216") )
}

