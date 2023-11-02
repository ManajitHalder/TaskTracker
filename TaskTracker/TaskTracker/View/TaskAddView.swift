//
//  TaskAddView.swift
//  
//  Created by Manajit Halder on 11/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct TaskAddView: View {
    @ObservedObject var taskMainViewModel: TaskMainViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var category: String = TaskCategory.personal.name()
    @State private var priority: String = TaskPriority.high.name()
    @State private var status: String = TaskStatus.notStarted.name()
    @State private var dueDate: Date = Date()
    
    @FocusState private var focusedField: Int? // To autofocus the mouse in the first text field.
    @State private var isFieldsEmptyAlertPresented: Bool = false // To present Save Alert
    
//    var taskCategory: TaskCategory = .personal
    
    func resetInputFields() {
        title = ""
        description = ""
        category = TaskCategory.personal.name()
        priority = TaskPriority.high.name()
        status = TaskStatus.notStarted.name()
        dueDate = Date()
    }
    
    var categories: [String] {
        var uniqueCategories = Set<String>()
        
        taskMainViewModel.allTasks.forEach { task in
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
                    ForEach(TaskCategory.allCases, id: \.self) { taskCategory in
                        Text(taskCategory.name()).tag(taskCategory.name())
                    }
                }
            }
            
            Section(header: Text("Task Priority")) {
                Picker("Priority", selection: $priority) {
                    ForEach(TaskPriority.allCases, id: \.self) { taskPriority in
                        Text(taskPriority.name()).tag(taskPriority.name())
                    }
                }
            }
            
            Section(header: Text("Task Status")) {
                Picker("Status", selection: $status) {
                    ForEach(TaskStatus.allCases, id: \.self) { taskStatus in
                        Text(taskStatus.name()).tag(taskStatus.name())
                    }
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
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
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
                            taskMainViewModel.addTask(newTask)
                            
                            // Update the picker style based upon the count of all tasks in the task list
                            taskMainViewModel.useSegmentedPickerStyle = categories.count > 6 ? false : true
                            
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
        TaskAddView(taskMainViewModel: TaskMainViewModel())
    }
}
