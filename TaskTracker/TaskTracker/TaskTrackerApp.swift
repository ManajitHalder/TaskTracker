//
//  TaskTrackerApp.swift
//  
//  Created by Manajit Halder on 09/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI
import UserNotifications

@main
struct TaskTrackerApp: App {
    let settingsViewModel = SettingsViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TaskMainView()
                    .environmentObject(settingsViewModel)
            }
        }
    }
}
