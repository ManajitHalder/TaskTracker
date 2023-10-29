//
//  TaskOperation.swift
//  
//  Created by Manajit Halder on 10/10/23 using Swift 5.0 on MacOS 13.4
//  

import Foundation
import Combine

final class TaskManager {
//    let update1 = Update(id: <#T##arg#>, text: <#T##String#>)
    func getAllTasks() -> [TaskItem] {
        [
            TaskItem(title: "Task 1", description: "Start your first project Task Trakcer to track daily tasks", category: "Personal", priority: "High", status: "Not Started", dueDate: Date()),
            TaskItem(title: "Task 5", description: "", category: "Work", priority: "High", status: "Not Started", dueDate: Date()),
            TaskItem(title: "Task 7", description: "", category: "Shopping", priority: "High", status: "Not Started", dueDate: Date()),
            TaskItem(title: "Task 9", description: "", category: "Wishlist", priority: "High", status: "Not Started", dueDate: Date()),
            TaskItem(title: "Task 12", description: "", category: "Travel", priority: "High", status: "Not Started", dueDate: Date()),
            TaskItem(title: "Task 15", description: "", category: "Hobby", priority: "High", status: "Not Started", dueDate: Date()),
            TaskItem(title: "Cook Khichdi", description: "Prepare Khichdi for dinner", category: "Other", priority: "High", status: "Not Started", dueDate: Date()),
            TaskItem(title: "I am loving this app.", description: "This app has boosted my confidence of app development using SwiftUI, Vapor, handing greate amout data, apiary, REST API, PostgreSQL.", category: "Work", priority: "High", status: "Not Started", dueDate: Date(), updates: [Update(text: "Started"), Update(text: "Preapared detailed plan"), Update(text: "Going good"), Update(text: "Learned so many things"), Update(text: "Finishing next week")]),
            TaskItem(title: "I am loving this app.", description: "This app has boosted my confidence of app development using SwiftUI, Vapor, handing greate amout data, apiary, REST API, PostgreSQL.", category: "Work", priority: "High", status: "Not Started", dueDate: Date(), updates: [Update(text: "Started"), Update(text: "Learning so many things on iOS and Swift. Going to implement backend next week."), Update(text: "Going good"), Update(text: "Learned so many things"), Update(text: "Finishing soon")])
        ]
    }
}

final class TaskViewModel: ObservableObject {
    
//    @Published var allTasks: [TaskItem] = [
//        TaskItem(title: "Task 1", description: "Start your first project Task Trakcer to track daily tasks", category: "Personal", priority: "High", status: "Not Started", dueDate: Date()),
//        TaskItem(title: "Task 5", description: "", category: "Work", priority: "High", status: "Not Started", dueDate: Date()),
//        TaskItem(title: "Task 7", description: "", category: "Shopping", priority: "High", status: "Not Started", dueDate: Date()),
//        TaskItem(title: "Task 9", description: "", category: "Wishlist", priority: "High", status: "Not Started", dueDate: Date()),
//        TaskItem(title: "Task 12", description: "", category: "Travel", priority: "High", status: "Not Started", dueDate: Date()),
//        TaskItem(title: "Task 15", description: "", category: "Hobby", priority: "High", status: "Not Started", dueDate: Date())
//    ]
    
    @Published var allTasks: [TaskItem] = []
    @Published private(set) var filteredTasks: [TaskItem] = []
    @Published private(set) var completedTasks = Set<TaskItem>() // To maintain a list of completed tasks.
    @Published var searchText: String = ""
    @Published var useSegmentedPickerStyle: Bool = false
    
    let taskManager = TaskManager()
    private var cancellables = Set<AnyCancellable>()
    
    func loadTasks() {
        allTasks = taskManager.getAllTasks()
//        Task {
//            do {
//                let tasks = taskManager.getAllTasks()
//                Task {
//                    allTasks = taskManager.getAllTasks()
//                }
//            } catch {
//                print("loadTasks(): \(error)")
//            }
//        }
    }
    
    
    
    //MARK: - SEARCH FUNCTIONALITIES
    
    var isSearching: Bool {
        !searchText.isEmpty
    }
    
    init() {
        loadTasks()
        addSubscribers()
    }
    
    private func addSubscribers() {
//        Task {
            $searchText
                .debounce(for: 0.5, scheduler: DispatchQueue.main)
                .sink { [weak self] searchText in
                    self?.filterTasks(searchText: searchText)
                }
                .store(in: &cancellables)
//        }
    }
    
    private func filterTasks(searchText: String) {
//        Task {
            guard !searchText.isEmpty else {
                return
            }
            
            let search = searchText.lowercased()
            filteredTasks = allTasks.filter({ task in
                let titleContainsSearchText = task.title.lowercased().contains(search)
                let categoryContainsSearchText = task.category.lowercased().contains(search)
                let priorityContainsSearchText = task.priority.lowercased().contains(search)
                let statusContainsSearchText = task.status.lowercased().contains(search)
                
                return titleContainsSearchText || categoryContainsSearchText || priorityContainsSearchText || statusContainsSearchText
            })
//        }
    }
    
    //MARK: - TASK OPERATIONS
    
    func addTask(_ task: TaskItem) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.allTasks.append(task)
        }
    }
    
    func updateTask(_ task: TaskItem) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if let taskIndex = allTasks.firstIndex(where: { $0.id == task.id }) {
                allTasks[taskIndex].title = task.title
                allTasks[taskIndex].description = task.description
                allTasks[taskIndex].category = task.category
                allTasks[taskIndex].priority = task.priority
                allTasks[taskIndex].status = task.status
                allTasks[taskIndex].dueDate = task.dueDate
                allTasks[taskIndex].updates = task.updates
            }
        }
    }
    
    func deleteTask(_ task: TaskItem) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            if let taskIndex = allTasks.firstIndex(where: { $0.id == task.id }) {
                self.allTasks.remove(at: taskIndex)
            }
        }
    }
    
    // Add task to the completedTask array
    func addCompletedTask(_ completedTask: TaskItem) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            print(completedTask.status)
            self.completedTasks.insert(completedTask)
        }
    }
    
    //MARK: - CONTEXT MENU OPERATIONS
    
    // Start task
    func startTask(_ task: TaskItem, _ status: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let taskIndex = allTasks.firstIndex(where:  { $0.id == task.id }) {
                print("Before \(task.id), \(task.status), \(status), allTask: \(allTasks[taskIndex].status)")
                allTasks[taskIndex].status = status
                print("After \(task.id), \(task.status), \(status), allTask: \(allTasks[taskIndex].status)")
            }
        }
    }
    
    // Complete task
    func completeTask(_ task: TaskItem, _ status: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let taskIndex = allTasks.firstIndex(where: { $0.id == task.id }) {
                print("Before \(task.id), \(task.status), \(status), allTask: \(allTasks[taskIndex].status)")
                allTasks[taskIndex].status = status
                print("After \(task.id), \(task.status), \(status), allTask: \(allTasks[taskIndex].status)")
            }
        }
    }
    
    //MARK: - TASK FILTERING
    
}
