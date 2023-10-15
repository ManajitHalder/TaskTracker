//
//  TaskDetailView.swift
//  
//  Created by Manajit Halder on 12/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @State var task: Task
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var category: String = "Personal"
    @State private var priority: String = "High"
    @State private var status: String = "Not Started"
    @State private var dueDate: Date = Date()
    
    var body: some View {
        Form {
            Section(header: Text("Task Title / Heading")) {
                TextField("Title", text: $title)
            }
            
            Section(header: Text("Task Description")) {
                TextEditor(text: $description)
            }
            
            Section(header: Text("Task Category / Type")) {
                Picker("Category", selection: $category) {
                    Text("Personal").tag("Personal")
                    Text("Study").tag("Study")
                    Text("Work").tag("Work")
                    Text("Health & Fitness").tag("Health & Fitness")
                    Text("Travel").tag("Travel")
                    Text("Entertainment").tag("Entertainment")
                    Text("Shopping").tag("Shopping")
                    Text("Hobby").tag("Hobby")
                    Text("Wishlist").tag("Wishlist")
                    Text("Household").tag("Household")
                }
            }
            
            Section(header: Text("Task Priority")) {
                Picker("Priority", selection: $priority) {
                    Text("High").tag("High")
                    Text("Medium").tag("Medium")
                    Text("Low").tag("Low")
                    Text("Urgent").tag("Urgent")
                    Text("Routine").tag("Routine")
                    Text("Critical").tag("Critical")
                }
            }
            
            Section(header: Text("Task Status")) {
                Picker("Status", selection: $status) {
                    Text("Not Started").tag("Not Started")
                    Text("In Progress").tag("In Progress")
                    Text("Completed").tag("Completed")
                    Text("Cancelled").tag("Cancelled")
                    Text("Deferred").tag("Deferred")
                    Text("Overdue").tag("Overdue")
                }
            }
            Section(header: Text("Task Due Date")) {
                DatePicker(
                    "Due Date",
                    selection: $dueDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
            }
            Section(header: Text("")) {
                Button("Update") {
                    let newTask = Task(id: task.id,
                                       title: title,
                                       description: description,
                                       category: category,
                                       priority: priority,
                                       status: status,
                                       dueDate: dueDate
                    )
//                    print("update called")
                    if title.isEmpty || description.isEmpty {
                        //
                    } else {
                        taskViewModel.updateTask(newTask)
                        print("task updated")
                        print(newTask.title, newTask.description, newTask.category, newTask.priority, newTask.status, newTask.dueDate, separator: " ")
                    }
                }
            }
        }
        .navigationTitle(task.title)
        .onAppear {
            title = task.title
            description = task.description
            category = task.category
            priority = task.priority
            status = task.status
            dueDate = task.dueDate
        }

    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(taskViewModel: TaskViewModel(), task: Task(title: "", description: "", dueDate: Date()))
    }
}
