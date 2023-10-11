//
//  TaskOperation.swift
//  
//  Created by Manajit Halder on 10/10/23 using Swift 5.0 on MacOS 13.4
//  

import Foundation


class TaskViewModel: ObservableObject {
    
    @Published var tasks: [Task] = [
        Task(title: "Task 1", description: ": Start your first project Task Trakcer to track daily tasks with different criteria like task category, priority, task notification, ...", dueDate: Date(), category: "Personal"),
//        Task(title: "Task 2", description: "", category: "Personal"),
//        Task(title: "Task 3", description: "", category: "Personal"),
//        Task(title: "Task 4", description: "", category: "Work"),
        Task(title: "Task 5", description: "", dueDate: Date(), category: "Work"),
//        Task(title: "Task 6", description: "", category: "Shopping"),
        Task(title: "Task 7", description: "", dueDate: Date(), category: "Shopping"),
//        Task(title: "Task 8", description: "", category: "Wishlist"),
        Task(title: "Task 9", description: "", dueDate: Date(), category: "Wishlist"),
//        Task(title: "Task 10", description: "", category: "Wishlist"),
//        Task(title: "Task 11", description: "", category: "Critical"),
        Task(title: "Task 12", description: "", dueDate: Date(), category: "Critical"),
//        Task(title: "Task 13", description: "", category: "Hobby"),
//        Task(title: "Task 14", description: "", category: "Hobby"),
        Task(title: "Task 15", description: "", dueDate: Date(), category: "Hobby")
    ]
    
    func addTask(_ task: Task) {
        print("adding task:")
        tasks.append(task)
        print(tasks.count)
    }
    
    func deleteTask(index taskIndex: Int) {
        if !tasks.isEmpty {
            tasks.remove(at: taskIndex)
        }
    }
}
