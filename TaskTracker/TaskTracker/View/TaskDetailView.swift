//
//  TaskDetailView.swift
//  
//  Created by Manajit Halder on 12/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode

    @State var task: Task

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var category: String = "Personal"
    @State private var priority: String = "High"
    @State private var status: String = "Not Started"
    @State private var dueDate: Date = Date()
    @State private var updates: [Update] = []
    
    @State private var statusUpdateText: String = ""

    @State private var isEmptyFieldPresented: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("Task Title / Heading")) {
                TextField("Title", text: $title)
            }
            
            Section(header: Text("Task Description")) {
                TextEditor(text: $description)
                    .frame(minHeight: 70, idealHeight: 150, maxHeight: .infinity)
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
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            
            Section(header: Text("Task Status Update")) {
                HStack {
                    TextField("Add an Update", text: $statusUpdateText)
                    Button {
                        if !statusUpdateText.isEmpty {
                            updates.append(Update(text: statusUpdateText))
                            statusUpdateText = ""
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.custom("Cochin", size: 20))
                    }
                }
                List {
                    ForEach(updates) { update in
                        Text(update.text)
                    }
                }
            }
        }
        .onAppear {
            title = task.title
            description = task.description
            category = task.category
            priority = task.priority
            status = task.status
            dueDate = task.dueDate
            updates = task.updates
        }
        .navigationTitle("Task")
        .navigationBarItems(
            trailing:
                Button("Save") {
                    let newTask = Task(id: task.id,
                                       title: title,
                                       description: description,
                                       category: category,
                                       priority: priority,
                                       status: status,
                                       dueDate: dueDate,
                                       updates: updates
                    )
                    if title.isEmpty || description.isEmpty {
                        /*
                         dismiss the keyboard before presenting the alert to avoid layout constraint of the system input assistant view error.
                        */
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil)
                        
                        isEmptyFieldPresented = true
                    } else {
                        taskViewModel.updateTask(newTask)
                    }
                }
        )
        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden(true) // Hide the automatically created "Back" button
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(taskViewModel: TaskViewModel(), task: Task(title: "", description: "", dueDate: Date()))
    }
}
