//
//  TaskItem.swift
//  
//  Created by Manajit Halder on 09/10/23 using Swift 5.0 on MacOS 13.4
//  

import Foundation

struct Update: Identifiable, Hashable {
    var id = UUID()
    var text: String
}

struct TaskItem: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var description: String
    var category: String = ""
    var priority: String = ""
    var status: String = ""
    var dueDate: Date
    var updates: [Update] = []
}




