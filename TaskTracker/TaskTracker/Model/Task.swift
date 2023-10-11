//
//  TaskCategories.swift
//  
//  Created by Manajit Halder on 09/10/23 using Swift 5.0 on MacOS 13.4
//  

import Foundation

struct Task: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var description: String
    var priority: String = ""
    var dueDate: Date
    var category: String = ""
    var status: String = ""
    var updates: [String] = []
}




