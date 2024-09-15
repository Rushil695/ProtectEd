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
                Color.main.opacity(0.9).ignoresSafeArea()
                
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.4))
                
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                
                VStack {
                        
                    Image("shield-check 1").resizable()
                        .frame(width: 100, height: 100)
                        .padding(.bottom, 30)
    
                    
                    Text("Login")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.black)
                    
                    HStack {
                        TextField("Email", text: $username)
                        
                            .padding()
                            .frame(width: 280, height: 50)
                            .cornerRadius(45)
                            .border(Color.red, width: CGFloat(wrongUsername))
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            Image(systemName: "envelope.fill").foregroundStyle(.black)
                            
                        }

                    .background(RoundedRectangle(cornerRadius: 35).fill(.gray).opacity(0.2))
                    .shadow(radius:2)
                    
                    .padding()
                    
                    HStack {
                        SecureField("Password", text: $password)
                        
                            .padding()
                            .frame(width: 280, height: 50)
                            .cornerRadius(45)
                            .cornerRadius(10)
                            .border(Color.red, width: CGFloat(wrongPassword))
                            Image(systemName: "key.fill").foregroundStyle(.black)
                    }

                    .background(RoundedRectangle(cornerRadius: 35).fill(.gray).opacity(0.2))
                    .shadow(radius:2)
                    
                    
                    
                    Button(action: {
                        authenticateUser(username: username, password: password)
                    }, label: {
                        Text("Login")
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.main)
                            .cornerRadius(10)
                            .padding()
                            
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
        if username.lowercased() == "grover@vt.edu" || username.lowercased() == "madhu@vt.edu" || username.lowercased() == "choudhary@vt.edu"{
            wrongUsername = 0
            if password.lowercased() == "goHokies" {
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
