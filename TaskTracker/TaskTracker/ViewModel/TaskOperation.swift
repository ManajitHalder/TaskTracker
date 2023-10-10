//
//  TaskOperation.swift
//  
//  Created by Manajit Halder on 10/10/23 using Swift 5.0 on MacOS 13.4
//  

import Foundation


class TaskViewModel: ObservableObject {
    @Published var tasks = [
//        Task(title: "Task 1: Start your first project Task Trakcer to track daily tasks with different criteria like task category, priority, task notification, ...", category: "Personal"),
        Task(title: "Task 2", category: "Personal"),
        Task(title: "Task 3", category: "Personal"),
        Task(title: "Task 4", category: "Work"),
        Task(title: "Task 5", category: "Work"),
        Task(title: "Task 6", category: "Shopping"),
        Task(title: "Task 7", category: "Shopping"),
        Task(title: "Task 8", category: "Wishlist"),
        Task(title: "Task 9", category: "Wishlist"),
        Task(title: "Task 10", category: "Wishlist"),
        Task(title: "Task 11", category: "Critical"),
        Task(title: "Task 12", category: "Critical"),
        Task(title: "Task 13", category: "Hobby"),
        Task(title: "Task 14", category: "Hobby"),
        Task(title: "Task 15", category: "Hobby")
    ]
    
    func addTask(title taskTitle: String, category taskCategory: String) {
        tasks.append(Task(title: taskTitle, category: taskCategory))
    }
    
    func deleteTask(index taskIndex: Int) {
        if !tasks.isEmpty {
            tasks.remove(at: taskIndex)
        }
    }
}
