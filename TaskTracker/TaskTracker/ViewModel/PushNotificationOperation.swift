//
//  PushNotificationOperation.swift
//  
//  Created by Manajit Halder on 05/11/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct PushNotification {
    static func addRequest() {
        let content = UNMutableNotificationContent()
        
        content.title = "Notifications with actions"
        content.subtitle = "Notification has subtitle"
        content.body = "Notification has body"
        content.sound = UNNotificationSound.defaultRingtone
        
        let actionA = UNNotificationAction(identifier: "actionA", title: "action A", options: [])
        let actionB = UNNotificationAction(identifier: "actionB", title: "action B", options: [])
        
        let category = UNNotificationCategory(identifier: "notificationCategory", actions: [actionA, actionB], intentIdentifiers: [], options: [])
        content.categoryIdentifier = "notificationCategory"
        
        UNUserNotificationCenter.current().setNotificationCategories([category]) // Register the category
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false) // 10 seconds delay
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error in scheduling notification: \(error)")
            } else {
                print("Notification scheduled")
            }
        }
    }
}
