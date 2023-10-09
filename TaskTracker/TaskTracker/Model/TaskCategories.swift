//
//  TaskCategories.swift
//  
//  Created by Manajit Halder on 09/10/23 using Swift 5.0 on MacOS 13.4
//  

import Foundation

struct TaskCategories: Identifiable {
    var id = UUID()
    var title: String
    var category: String
}

let tasks = [
    TaskCategories(title: "Task 1", category: "Personal"),
    TaskCategories(title: "Task 2", category: "Work"),
    TaskCategories(title: "Task 3", category: "Shopping"),
    TaskCategories(title: "Task 4", category: "Wishlist"),
    TaskCategories(title: "Task 5", category: "Critical"),
    TaskCategories(title: "Task 6", category: "Hobby")
]
