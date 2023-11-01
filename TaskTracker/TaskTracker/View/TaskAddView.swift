//
//  TaskAddView.swift
//  
//  Created by Manajit Halder on 11/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct TaskAddView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var category: String = "Personal"
    @State private var priority: String = "High"
    @State private var status: String = "Not Started"
    @State private var dueDate: Date = Date()
    
    @FocusState private var focusedField: Int? // To autofocus the mouse in the first text field.
    @State private var isFieldsEmptyAlertPresented: Bool = false // To present Save Alert
    
    func resetInputFields() {
        title = ""
        description = ""
        category = "Personal"
        priority = "High"
        status = "Not Started"
        dueDate = Date()
    }
    
    var categories: [String] {
        var uniqueCategories = Set<String>()
        
        taskViewModel.allTasks.forEach { task in
            uniqueCategories.insert(task.category)
        }
        
        return Array(uniqueCategories) + ["All"]
    }
    
    var body: some View {
        Form {
            Section(header: Text("Task Title / Heading")) {
                TextField("Title", text: $title)
                    .focused($focusedField, equals: 0)
                    .onSubmit {
                        // Move focus to the next field when the user preses return/enter.
                        focusedField = 1
                    }
            }
            
            Section(header: Text("Task Description")) {
                TextEditor(text: $description)
                    .frame(minHeight: 70)
                    .focused($focusedField, equals: 1)
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
            .frame(maxHeight: 80)
        }
        .onAppear {
            focusedField = 0
        }
        .navigationBarItems (
            leading:
                Button("Back"){
                    // Reset the input fields to defaults
                    resetInputFields()
                    // Go to previous screen
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.bordered)
                .contentShape(Rectangle())
                .background(Color.black.opacity(0.055))
                .cornerRadius(10)
                .frame(width: 80, height: 40)
            ,
            trailing:
                Button("Save") {
                    Task {
                        
                        /* Add your save action here */
                        
                        let newTask = TaskItem(title: title,
                                               description: description,
                                               category: category,
                                               priority: priority,
                                               status: status,
                                               taskDate: TaskDate(startDate: "", dueDate: DateUtils.dateToString(dueDate), finisDate: "")
                        )
                        
                        // Add the newTask to taskList
                        if title.isEmpty || description.isEmpty {
                            /*
                             dismiss the keyboard before presenting the alert to avoid layout constraint of the system input assistant view error.
                            */
                            UIApplication.shared.sendAction(
                                #selector(UIResponder.resignFirstResponder),
                                to: nil,
                                from: nil,
                                for: nil)
                            isFieldsEmptyAlertPresented = true
                        } else {
                            taskViewModel.addTask(newTask)
                            
                            // Update the picker style based upon the count of all tasks in the task list
                            taskViewModel.useSegmentedPickerStyle = categories.count > 6 ? false : true
                            
                            // Go back to previous screen
                            presentationMode.wrappedValue.dismiss()
                        }
                        // Reset the input fields to defaults
                        resetInputFields()
                    }
                }
                .buttonStyle(.bordered)
                .contentShape(Rectangle())
                .background(Color.black.opacity(0.055))
                .cornerRadius(10)
                .frame(width: 80, height: 40)
            
                .alert(isPresented: $isFieldsEmptyAlertPresented, content: {
                    Alert(
                        title: Text("Empty Fields"),
                        message: Text("Title and Description Empty."),
                        dismissButton: .default(Text("OK"), action: {
                            isFieldsEmptyAlertPresented = false
                        })
                    )
                })
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // Hide the automatically created "Back" button
    }
}

struct TaskAddView_Previews: PreviewProvider {
    static var previews: some View {
        TaskAddView(taskViewModel: TaskViewModel())
    }
}
