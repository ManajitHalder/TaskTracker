//
//  SettingsOperation.swift
//  
//  Created by Manajit Halder on 28/10/23 using Swift 5.0 on MacOS 13.4
//  

import Foundation

final class SettingsViewModel: ObservableObject {
    @Published var isDarkModeEnabled: Bool = false
}
