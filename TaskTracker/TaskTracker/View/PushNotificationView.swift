//
//  PushNotificationView.swift
//  
//  Created by Manajit Halder on 05/11/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct PushNotificationView: View {
    var body: some View {
        Button("Send Notification") {
            PushNotification.addRequest()
        }
    }
}

struct PushNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        PushNotificationView()
    }
}
