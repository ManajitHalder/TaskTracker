//
//  SettingsView.swift
//  
//  Created by Manajit Halder on 27/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userSettings: SettingsViewModel
    //    @AppStorage("colorScheme") var colorScheme = ColorSchemeOptions.light
    @State private var isEditingProfile: Bool = false
    @State private var isAboutUsEnabled: Bool = false
    @State private var isNewFeaturesViewEnabled: Bool = false
    
    var body: some View {
        ZStack {
            backgroudColor()
                .ignoresSafeArea(.all)
            
            VStack {
                List {
                    Section("General Settings") {
                        Picker(selection: $userSettings.language) {
                            ForEach(LanguageOptions.allCases, id: \.self) { lang in
                                Text(lang.rawValue.capitalized).tag(lang.rawValue)
                            }
                        } label: {
                            Label("Language", systemImage: "globe")
                        }
                        
                        Toggle(isOn: $userSettings.isNotificationEnabled) {
                            Label("Notification", systemImage: "bell")
                        }
                    }
                    
                    Section("Account Settings") {
                        Text("Sign in/sign out: Manage user accounts")
                        Text("Profile settings: Edit user profile information")
                        
                        NavigationLink(destination: EditUserProfile()) {
                            Label("Edit", systemImage: "pencil")
                                .navigationTitle("Edit User Profile")
                        }
                        
                        Button("Edit Profile") {
                            isEditingProfile.toggle()
                        }
                        .sheet(isPresented: $isEditingProfile) {
                            EditUserProfile()
                        }
                        
                        Text("Password settings: Change or reset passwords")
                    }
                    
                    Section("Display and Appearance") {
                        Slider(value: $userSettings.fontSize, in: 10...40) {
                            Label("Font Size", systemImage: "text.magnifyingglass")
                        }
                        
                        Toggle(isOn: $userSettings.isDarkModeEnabled) {
                            Label("Dark Mode", systemImage: "moon")
                        }
                        
                        Text("Theme settings: Customize app appearance.")
                    }
                    
                    Section {
                        HStack {
                            Text("Support")
                            Spacer()
                            Image(systemName: "questionmark")
                        }

                        Button {
                            isAboutUsEnabled.toggle()
                        } label: {
                            Label("About Us", systemImage: "info")
                        }
                        .sheet(isPresented: $isAboutUsEnabled) {
                            AboutUsView()
                        }

                        
//                        Button("About Us") {
//                            isAboutUsEnabled.toggle()
//                        }
//                        .sheet(isPresented: $isAboutUsEnabled) {
//                            AboutUsView()
//                        } 
                        
                        Button("New Features") {
                            isNewFeaturesViewEnabled.toggle()
                        }
                        .sheet(isPresented: $isNewFeaturesViewEnabled) {
                            NewFeaturesViews()
                        }
                        
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.1.0")
                        }
                    } header: {
                        Text("About and Help")
                    }
                }
                .listStyle(.grouped)
                .listRowBackground(backgroudColor())
                .scrollContentBackground(.hidden)
            }
            .padding([.leading, .trailing])
            .cornerRadius(5)
        }
    }
    
    func backgroudColor() -> Color {
        return userSettings.isDarkModeEnabled ? Color.black : Color.white
    }
}

struct AboutUsView: View {
    var body: some View {
        VStack {
            Text("About Us")
                .bold()
                .padding(.bottom, 20)
            
            Text("""
             Task Tracker is a group of application developers who develops apps in iOS, Android and also develops websites for their own apps.
             \nPlease contact us if you need such apps. We will develops such types of apps for you.
             """)
        }
        .font(.custom("Cochin", size: 20))
        .fontDesign(.rounded)
        .padding()
        .foregroundColor(.indigo)
        .multilineTextAlignment(.center)
        
        .presentationDetents([.fraction(0.4)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(40.0)
    }
}

struct NewFeaturesViews: View {
    var body: some View {
        VStack {
            Text("New Changes")
                .bold()
                .padding(.bottom, 20)
            
            Text("""
             Task Tracker is a group of application developers who develops apps in iOS, Android and also develops websites for their own apps.
             \nPlease contact us if you need such apps. We will develops such types of apps for you.
             """)
        }
        .font(.custom("Cochin", size: 20))
        .fontDesign(.rounded)
        .padding()
        .foregroundColor(.indigo)
        .multilineTextAlignment(.center)
        
        .presentationDetents([.fraction(0.4)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(40.0)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
