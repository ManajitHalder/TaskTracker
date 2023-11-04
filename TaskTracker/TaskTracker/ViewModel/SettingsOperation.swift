//
//  SettingsOperation.swift
//  
//  Created by Manajit Halder on 28/10/23 using Swift 5.0 on MacOS 13.4
//  

import Foundation

enum LanguageOptions: String, CaseIterable {
    case bengali
    case hindi
    case kannada
    case english
}

final class SettingsViewModel: ObservableObject {
    @Published var isDarkModeEnabled: Bool = false
    @Published var fontSize: CGFloat = 16
    @Published var language: LanguageOptions = .bengali
    @Published var isNotificationEnabled: Bool = false
}
