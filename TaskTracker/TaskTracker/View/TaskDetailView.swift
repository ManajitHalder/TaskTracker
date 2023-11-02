//
//  TaskDetailView.swift
//  
//  Created by Manajit Halder on 12/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var taskMainViewModel: TaskMainViewModel
    @Environment(\.presentationMode) var presentationMode

    @State var task: TaskItem

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var category: String = TaskCategory.personal.name()
    @State private var priority: String = TaskPriority.high.name()
    @State private var status: String = TaskStatus.notStarted.name()
    @State private var dueDate: Date = Date()
    @State private var updates: [Update] = []
    
    @State private var statusUpdate: String = ""

    @State private var isEmptyFieldPresented: Bool = false
    
    var categories: [String] {
        var uniqueCategories = Set<String>()
        
        taskMainViewModel.allTasks.forEach { task in
            uniqueCategories.insert(task.category)
        }
        
        return Array(uniqueCategories) + ["All"]
    }
    
    var body: some View {
        Form {
//            Section(header: Text("Task Title / Heading")) {
            Section {
                TextField("Title", text: $title)
            }
            
//            Section(header: Text("Task Description")) {
            Section {
                TextEditor(text: $description)
                    .frame(minHeight: 70)
            }
            
//            Section(header: Text("Task Status Update")) {
            Section {
                HStack {
                    TextField("Add an Update", text: $statusUpdate)
                    Button {
                        if !statusUpdate.isEmpty {
                            updates.append(Update(text: statusUpdate))
                            statusUpdate = ""
                            status = TaskStatus.inProgress.name()
                            taskMainViewModel.startTask(task, status, Date())
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.custom("Cochin", size: 20))
                    }
                }
                List {
                    ForEach(updates.reversed()) { update in
                        Text(update.text)
                    }
                }
            }
            
//            Section(header: Text("Task Category / Type")) {
            Section {
                Picker("Category", selection: $category) {
                    ForEach(TaskCategory.allCases, id: \.self) { taskCategory in
                        Text(taskCategory.name()).tag(taskCategory.name())
                    }
                }
            }
            
//            Section(header: Text("Task Priority")) {
            Section {
                Picker("Priority", selection: $priority) {
                    ForEach(TaskPriority.allCases, id: \.self) { taskPriority in
                        Text(taskPriority.name()).tag(taskPriority.name())
                    }
                }
            }
            
//            Section(header: Text("Task Status")) {
            Section {
                Picker("Status", selection: $status) {
                    ForEach(TaskStatus.allCases, id: \.self) { taskStatus in
                        Text(taskStatus.name()).tag(taskStatus.name())
                    }
                }
            }
            
//            Section(header: Text("Task Due Date")) {
            Section {
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
        }
        .onAppear {
            title = task.title
            description = task.description
            category = task.category
            priority = task.priority
            status = task.status
            dueDate = DateUtils.stringToDate(task.taskDate.dueDate)!
            updates = task.updates
        }
        .navigationTitle("Task")
        .navigationBarItems(
            leading:
                Button(action: {
                    // Go back to previous screen
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                })
                .padding(.leading, 10)
            
            , trailing:
                Button("Save") {
                    let newTask = TaskItem(id: task.id,
                                       title: title,
                                       description: description,
                                       category: category,
                                       priority: priority,
                                       status: status,
                                        taskDate: TaskDate(startDate: "", dueDate: DateUtils.dateToString(dueDate), finisDate: ""),
                                       updates: updates
                    )
                    
                    task.title = title
                    task.description = description
                    task.category = category
                    task.priority = priority
                    task.status = status
                    task.taskDate.dueDate = DateUtils.dateToString(dueDate)
                    task.updates = updates
                    
                    if status == TaskStatus.inProgress.name() {
                        taskMainViewModel.startTask(task, status, Date())
                    }
                    if status == TaskStatus.completed.name() {
                        taskMainViewModel.completeTask(task, status, Date())
                        
                        // Update the picker style based upon the count of all tasks in the task list
                        taskMainViewModel.useSegmentedPickerStyle = categories.count > 6 ? false : true
                    }
                    
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
                        taskMainViewModel.updateTask(newTask)
                        // Go back to previous screen
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding(.trailing, 20)
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // Hide the automatically created "Back" button
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(taskMainViewModel: TaskMainViewModel(), task: TaskItem())
    }
}
