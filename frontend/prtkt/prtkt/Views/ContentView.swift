//
//  ContentView.swift
//  prtkt
//
//  Created by Advay Choudhury on 9/5/24.
//

import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername: Float = 0
    @State private var wrongPassword: Float = 0
    @State private var showingLoginScreen = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.main.opacity(0.8)
                
                    .ignoresSafeArea()
                
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                
                VStack {
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .foregroundStyle(.black)
                    
                    TextField("Username", text: $username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(10)
                        .border(Color.red, width: CGFloat(wrongUsername))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .foregroundStyle(.black)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(10)
                        .border(Color.red, width: CGFloat(wrongPassword))
                    
                    Button(action: {
                        authenticateUser(username: username, password: password)
                    }, label: {
                        Text("Login")
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.main)
                            .cornerRadius(10)
                    })
                    .padding()
                    
                    
                }
                .padding()
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showingLoginScreen) {
                ScheduleView()
        }
        }
    }

    func authenticateUser(username: String, password: String) {
        if username.lowercased() == "mario2021" {
            wrongUsername = 0
            if password.lowercased() == "abc123" {
                wrongPassword = 0
                showingLoginScreen = true
            } else {
                wrongPassword = 2
            }
        } else {
            wrongUsername = 2
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
