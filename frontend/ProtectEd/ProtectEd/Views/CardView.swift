//
//  TestView.swift
//  prtkt
//
//  Created by Rushil Madhu on 9/13/24.
//

import SwiftUI
import MapKit

struct CardView: View {
    @Binding var detection : String
    @EnvironmentObject var audiovm : AudioClassifier
    @Binding var position : MapCameraPosition
    @Binding var room: String
    
    var body: some View {
        if detection == ""  {
            GeometryReader { proxy in
                VStack {
                    Button(action: {
                        audiovm.start()
                    }, label: {
                        Text("SAFE")
                            .font(.largeTitle)
                            .padding(.top, 17.0)
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .bold()
                        
                    })
                    RoundedRectangle(cornerRadius: 25.0)
                        .frame(width: 380, height:3)
                        .lineLimit(1)
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
                        .padding(.leading, -3.0)
                        .padding(.bottom, 50.0)
                        .padding()
                        VStack {
                            Text("Current Room : ")
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .font(.title)
                                .bold()
                                .padding(.top, -45.0)
                                .padding(.bottom, 34.0)
                            Text(room)
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .font(.title)
                                .padding(.top, -45.0)
                        }
                    }
                    HStack {
                        Text("Next Class: " + room)
                            .font(.custom("Extra", size: 24))
                            .foregroundStyle(.main)
                            .padding()

                        Image(systemName: "arrow.forward").foregroundStyle(.main)
                            .imageScale(.medium).padding(.trailing)
                        
                    }
                    .background(RoundedRectangle(cornerRadius: 30)).foregroundStyle(.white)
                    
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
                    Text("DANGER!!!!")
                        .font(.largeTitle)
                        .padding(.top, 17.0)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .bold()
                    RoundedRectangle(cornerRadius: 25.0)
                        .frame(width: 380, height:3)
                        .lineLimit(1)
                    
                        .foregroundStyle(.white)
                    HStack {
                        
                        Button(action: {
                            withAnimation {
                                position = .camera(
                                    .init(centerCoordinate: CLLocationCoordinate2D(latitude: 37.23125, longitude: -80.42744), distance: 380)
                                )}})
                        {
                            Image("exit1")
                                .resizable()
                        }
                        .background(RoundedRectangle(cornerRadius: 20))
                        .frame(width: 130, height: 90)
                        .padding(.leading, -3.0)
                        .padding(.bottom, 50.0)
                        .padding()
                        VStack {
                            Text("Head to Exit: 1")
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .font(.title2)
                                .bold()
                                .padding(.top, -45.0)
                                .padding(.bottom, 34.0)
                            Text("")
                                .foregroundStyle(.white)
                                .lineLimit(1)
                                .font(.title)
                                .padding(.top, -45.0)
                        }
                    }
                    HStack {
                        Text("Detected through \(detection)")
                            .font(.custom("Extra", size: 23))
                            .foregroundStyle(.red)
                            .padding()
                    }
                    .background(RoundedRectangle(cornerRadius: 30)).foregroundStyle(.white)
                    
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

