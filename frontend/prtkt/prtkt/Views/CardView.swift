//
//  TestView.swift
//  prtkt
//
//  Created by Rushil Madhu on 9/13/24.
//

import SwiftUI
import MapKit

struct CardView: View {
    @Binding var detection : Bool
    
    @Binding var position : MapCameraPosition
    @Binding var room: String
    
    var body: some View {
        if !detection  {
            GeometryReader { proxy in
                VStack {
                    Text("SAFE")
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
                    Text("SAFE")
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
                            .imageScale(.medium).padding(.leading)
                    }
                    .background(RoundedRectangle(cornerRadius: 30)).foregroundStyle(.white)
                    
                    .padding([.leading, .bottom, .trailing])
                    .padding(.top, -57.0)
                    
                }
                .background(RoundedRectangle(cornerRadius: 30)).foregroundStyle(.main)
                .frame(width: proxy.size.width, height: proxy.size.height / 0.6)
            }
        }
    }
}

#Preview {
    CardView(detection: .constant(false), position: .constant(.camera(
        .init(centerCoordinate: CLLocationCoordinate2D(latitude: 37.23125, longitude: -80.42744), distance: 380))),room: .constant("CMSC216") )
}


//                    ZStack {
//                        RoundedRectangle(cornerRadius: 40)
//                            .opacity(1.0)
//                            .padding([.top, .leading, .trailing])
//                            .padding()
//                            .frame(width: 250, height: 120)
//                            .foregroundStyle(Color.main.opacity(0))
//                        RoundedRectangle(cornerRadius: 40)
//                            .opacity(1.0)
//                            .padding([.top, .leading, .trailing])
//                            .padding()
//                            .frame(width: 450, height: 310)
//                            .foregroundStyle(Color.main)
//
//                        VStack {
//                            HStack {
//                                Button(action: {
//                                    withAnimation {
//                                        position = .camera(
//                                            .init(centerCoordinate: CLLocationCoordinate2D(latitude: 37.23125, longitude: -80.42744), distance: 380)
//                                        )}})
//                                {
//                                    Image(systemName: "location.circle.fill")
//                                        .font(.title)
//                                }
//                                .frame(width: 100, height: 100)
//                                .padding(.leading, 26.0)
//                                .padding(.bottom, 50.0)
//
//                                Text("Currently in Room: ")
//                                    .font(.custom("TYPOGRAPH PRO Light", size: 20))
//                                    .bold()
//                                    .foregroundStyle(.white)
//                                    .padding()
//                                Spacer()
//                            }
//
//                            Text("Clear of Danger")
//                                .font(.custom("TYPOGRAPH PRO Light", size: 34))
//                                .foregroundStyle(.white)
//                                .padding(.bottom, 13.0)
//                            Text("Detecting through Audio and Video")
//                                .font(.custom("TYPOGRAPH PRO Light", size: 20))
//                                .foregroundStyle(.white)
//                        }
//                    }

