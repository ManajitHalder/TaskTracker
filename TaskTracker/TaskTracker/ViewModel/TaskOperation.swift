//
//  TaskOperation.swift
//  
//  Created by Manajit Halder on 10/10/23 using Swift 5.0 on MacOS 13.4
//  

import Foundation


class TaskViewModel: ObservableObject {
    
    @Published var tasks: [Task] = [
        Task(title: "Task 1", description: "Start your first project Task Trakcer to track daily tasks", category: "Personal", priority: "High", status: "Not Started", dueDate: Date()),
        Task(title: "Task 5", description: "", category: "Work", priority: "High", status: "Not Started", dueDate: Date()),
        Task(title: "Task 7", description: "", category: "Shopping", priority: "High", status: "Not Started", dueDate: Date()),
        Task(title: "Task 9", description: "", category: "Wishlist", priority: "High", status: "Not Started", dueDate: Date()),
        Task(title: "Task 12", description: "", category: "Travel", priority: "High", status: "Not Started", dueDate: Date()),
        Task(title: "Task 15", description: "", category: "Hobby", priority: "High", status: "Not Started", dueDate: Date())
    ]
    
    @Published var completedTasks: [Task] = [] // To maintain a list of completed tasks.
    
    func addTask(_ task: Task) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.tasks.append(task)
        }
    }
    
    func updateTask(_ task: Task) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let taskIndex = tasks.firstIndex(where: { $0.id == task.id }) {
                tasks[taskIndex].title = task.title
                tasks[taskIndex].description = task.description
                tasks[taskIndex].category = task.category
                tasks[taskIndex].priority = task.priority
                tasks[taskIndex].status = task.status
                tasks[taskIndex].dueDate = task.dueDate
                tasks[taskIndex].updates = task.updates
            }
        }
    }
    func deleteTask(_ task: Task) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
//            if !self.tasks.isEmpty && taskIndex >= 0 && taskIndex < self.tasks.count {
//                self.tasks.remove(at: taskIndex)
//            }
            if let taskIndex = tasks.firstIndex(where: { $0.id == task.id }) {
                self.tasks.remove(at: taskIndex)
            }
        }
    }
    
    // Add task to the completedTask array
    func addCompletedTask(_ completedTask: Task) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.completedTasks.append(completedTask)
        }
    }
    
    // Add update to the 
}
