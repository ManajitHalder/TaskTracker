//
//  TaskAddView.swift
//  
//  Created by Manajit Halder on 11/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct TaskAddView: View {
    @ObservedObject var taskList: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var category: String = "Personal"
    @State private var priority: String = "High"
    @State private var dueDate: Date = Date()
    @State private var status: String = ""
    @State private var update: String = ""
    
    @FocusState private var focusedField: Int? // To autofocus the mouse in the first text field.
    
    func resetInputFields() {
        title = ""
        description = ""
        category = "Personal"
        priority = "High"
        dueDate = Date()
        status = ""
        update = ""
    }
    
    func areFieldsNotEmpty() -> Bool {
        if title.isEmpty || description.isEmpty || status.isEmpty {
            return false
        }
        return true
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                        .focused($focusedField, equals: 0)
                        .onSubmit {
                            // Move focus to the next field when the user preses return/enter.
                            focusedField = 1
                        }
                    
                    TextField("Description", text: $description)
                        .focused($focusedField, equals: 1)
                        .onSubmit {
                            focusedField = 2
                        }
                    
                    TextField("Status", text: $status)
                        .focused($focusedField, equals: 2)
                        .onSubmit {
                            focusedField = 6
                        }
                }
                
                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $priority) {
                        Text("High").tag("High")
                        Text("Medium").tag("Medium")
                        Text("Low").tag("Low")
                        Text("Urgent").tag("Urgent")
                        Text("Routine").tag("Routine")
                        Text("Critical").tag("Critical")
                    }
                    .focused($focusedField, equals: 3)
                    .onChange(of: priority) { _ in
                        focusedField = 4
                    }
                }
                
                Section(header: Text("Due Date")) {
                    DatePicker(
                        "Due Date",
                        selection: $dueDate,
                        displayedComponents: .date
                    )
                }
                .focused($focusedField, equals: 4)
                .onChange(of: dueDate) { _ in
                    focusedField = 5
                }
                
                Section(header: Text("Task Category")) {
                    Picker("Category", selection: $category) {
                        Text("Personal").tag("Personal")
                        Text("Study").tag("Study")
                        Text("Work").tag("Work")
                        Text("Health & Fitness").tag("Health & Fitness")
                        Text("Travel").tag("Travel")
                        Text("Entertainment").tag("Entertainment")
                        Text("Shopping").tag("Shopping")
                        Text("Hobby").tag("Hobby")
                        Text("Household").tag("Household")

                    }
                }
               .focused($focusedField, equals: 5)
                .onChange(of: category) { _ in
                    focusedField = 6
                }
                
                Section(header: Text("Update")) {
                    TextField("Update", text: $update)
                        .focused($focusedField, equals: 6)
//                        .onSubmit {
//                            focusedField = 3
//                        }
                }
                
//                Section {
//                    HStack {
//                        Button {
//                            // Reset the input fields to defaults
//                            resetInputFields()
//                            // Go to previous screen
//                            presentationMode.wrappedValue.dismiss()
//
//                        } label: {
//                            Text("Cancel")
//                        }
//                        .buttonStyle(.bordered)
//                        .contentShape(Rectangle())
//                        .background(.red)
//                        .cornerRadius(10)
//                        .frame(width: 80, height: 40)
//
//                        Spacer()
//
//                        Button {
//                            let newTask = Task(title: title,
//                                               description: description,
//                                               priority: priority,
//                                               dueDate: dueDate,
//                                               category: category,
//                                               status: status
//                            )
//
//                            // Add the newTask to taskList
//                            if areFieldsNotEmpty() {
//                                taskList.addTask(newTask)
//                            }
//                            // Reset the input fields to defaults
//                            resetInputFields()
//
//                        } label: {
//                            Text("Save")
//                        }
//                        .buttonStyle(.bordered)
//                        .contentShape(Rectangle())
//                        .background(.green)
//                        .cornerRadius(10)
//                        .frame(width: 80, height: 40)
//                    }
//                }
//                .padding(.bottom, 20)
//                .listRowBackground(Color.clear)
            }
            .onAppear {
                focusedField = 0
            }
//            .padding(.bottom, 20)
//            .navigationTitle("Add Task")
            .navigationBarTitle("", displayMode: .inline) // Hide the default title
            .navigationBarItems(trailing: Button("Save") {
                /* Add your save action here */
                
                let newTask = Task(title: title,
                                   description: description,
                                   priority: priority,
                                   dueDate: dueDate,
                                   category: category,
                                   status: status
                )

                // Add the newTask to taskList
                if areFieldsNotEmpty() {
                    taskList.addTask(newTask)
                }
                // Reset the input fields to defaults
                resetInputFields()
            })
            .navigationBarItems(leading: Button("Cancle"){
                // Reset the input fields to defaults
                resetInputFields()
                // Go to previous screen
                presentationMode.wrappedValue.dismiss()
            })
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    // Custom navigation title with a smaller font
//                    Text("Add Task")
//                        .font(.system(size: 16)) // Adjust the font size as needed
//                        .foregroundColor(.primary)
//                }
//            }
        }
    }
}

struct TaskAddView_Previews: PreviewProvider {
    static var previews: some View {
        TaskAddView(taskList: TaskViewModel())
    }
}
