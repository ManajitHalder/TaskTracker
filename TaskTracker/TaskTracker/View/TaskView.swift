//
//  TaskView.swift
//  
//  Created by Manajit Halder on 09/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct TaskView: View {
    @StateObject private var taskViewModel = TaskViewModel()
    
    @State private var selectedCategory = "All"
    @State private var isAddingTask = false
    @State private var alternateColor = false
    
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    
    @State private var isSegmentedPickerStyle: Bool = false
    
    @EnvironmentObject var userSettings: SettingsViewModel
    
    @State private var status: String = "Not Started"
    @State private var taskDate: TaskDate = TaskDate()
            
    enum filterType {
        case taskCategory
        case taskSchedule
        case taskStatus
    }
    
    enum filterStatus {
        case inProgress
//        case completed
    }
    
    enum taskScheduleEnum {
        case today
        case upcoming
    }
    
    @State private var taskFilter: filterType = .taskCategory
    @State private var taskScheduleFilter: taskScheduleEnum = .today
    @State private var taskStatusFilter: filterStatus = .inProgress
    
    var categories: [String] {
        var uniqueCategories = Set<String>()
        
        taskViewModel.allTasks.forEach { task in
            uniqueCategories.insert(task.category)
        }
        
        return Array(uniqueCategories) + ["All"]
    }
    
    var filteredTasks: [TaskItem] {
        if selectedCategory == "All" {
            return taskViewModel.allTasks
        } else {
            return taskViewModel.allTasks.filter { $0.category == selectedCategory }
        }
    }
    
    func filterTasks() -> [TaskItem] {
        
        switch taskFilter {
        case .taskCategory:
            if selectedCategory == "All" {
                return taskViewModel.allTasks
            } else {
                return taskViewModel.allTasks.filter { $0.category == selectedCategory }
            }
            
        case .taskSchedule:
            switch taskScheduleFilter {
            case .today:
                let todaysDate = DateUtils.dateToString(Date())
                return taskViewModel.allTasks.filter { $0.taskDate.dueDate ==  todaysDate }
                
            case .upcoming:
                let todaysDate = DateUtils.dateToString(Date())
                return taskViewModel.allTasks.filter { $0.taskDate.dueDate >  todaysDate }
            }
            
        case .taskStatus:
            switch taskStatusFilter {
            case .inProgress:
                return taskViewModel.allTasks.filter { $0.status == "In Progress" }
//            case .completed:
//                print("taskStatusFilter: Completed")
            }
        }

//        return taskViewModel.allTasks
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            List {
                ForEach(taskViewModel.isSearching ? taskViewModel.filteredTasks : self.filterTasks(), id: \.self) { taskItem in
                    NavigationLink(destination: TaskDetailView(taskViewModel: taskViewModel, task: taskItem)) {
                        TaskListItemView(task: taskItem)
                            .contextMenu {
                                
                                Section(taskItem.title) {
                                    Button {
                                        status = "In Progress"
                                        taskViewModel.startTask(taskItem, status, Date())
                                    } label: {
                                        Label("Start", systemImage: "play.fill")
                                    }
                                    
                                    Button {
                                        status = "Completed"
                                        taskViewModel.completeTask(taskItem, status, Date())
                                        // Update the picker style based upon the count of all tasks in the task list
                                        taskViewModel.useSegmentedPickerStyle = categories.count > 6 ? false : true
                                    } label: {
                                        Label("Complete", systemImage: "c.square.fill")
                                    }
                                }
                            }
                    }
                }
                .onDelete(perform: deleteTask)
                .listRowBackground(getListRowColor(alternateColor))
            }
            .searchable(text: $taskViewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search Task")
            
            HStack {
                if taskViewModel.useSegmentedPickerStyle {
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onAppear {
                        taskFilter = .taskCategory
                    }
                    .onChange(of: selectedCategory) { _ in
                        taskFilter = .taskCategory
                    }
                } else {
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    .onAppear {
                        taskFilter = .taskCategory
                    }
                    .onChange(of: selectedCategory) { _ in
                        taskFilter = .taskCategory
                    }
                }
            }
            .padding([.leading, .trailing], 20)
            .padding([.top, .bottom], 10)
            .background(Color.orange.opacity(0.2))
            
            HStack {
                
                Spacer()
                
                // Plus Circle for adding Tasks
                ZStack {
                    Circle() // Outer circle (larger)
                        .padding(.bottom, 20)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                    
                    Button(action: {
                        isAddingTask.toggle()
                    }) {
                        NavigationLink(destination: TaskAddView(taskViewModel: taskViewModel)) {
                            Image(systemName: "plus")
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        }
                        .navigationBarTitle("\(selectedCategory) Tasks", displayMode: .inline)
                    }
                    .frame(width: 20, height: 20)
                    .padding()
                    .background(Color.yellow)
                    .clipShape(Circle())
                    .padding(.bottom, 20)
                }
                
                Spacer()
            }
            .frame(maxHeight: 40)
            .background(.bar)
        }
        .navigationBarItems(
            leading:
                Menu(content: {
                    Button {
                        taskFilter = .taskSchedule
                        taskScheduleFilter = .upcoming
                    } label: {
                        Text("Upcoming").tag("Upcoming")
                    }
                    
                    Button {
                        taskFilter = .taskSchedule
                        taskScheduleFilter = .today
                    } label: {
                        Text("Today").tag("Today")
                    }
                    
                    Divider()
                    
                    Section("Status") {
                        NavigationLink("Completed") {
                            CompletedTaskView(taskViewModel: taskViewModel)
                        }
                        
                        Button {
                            taskFilter = .taskStatus
                            taskStatusFilter = .inProgress
                        } label: {
                            Text("In Progress").tag("In Progress")
                        }
                    }
                }, label: {
                    Label("Menu", systemImage: "line.3.horizontal")
                        .font(.custom("Cochin", size: 15))
                        .foregroundColor(.black)
                })
            , trailing:
                Menu {
                    NavigationLink("Settings") {
                        SettingsView()
                    }
                    
                    Button {
                    } label: {
                        Text("item1")
                    }
                } label: {
                    Label("", systemImage: "ellipsis")
                        .font(.custom("Cochin", size: 15))
                        .rotationEffect(.degrees(90))
                        .foregroundColor(.black)
                }
        )
    }
    
    func getListRowColor(_ color: Bool) -> Color {
        return Color.orange.opacity(0.08)
    }
    
    // Delete task at swipe from right to left.
    func deleteTask(at offset: IndexSet) {
        taskViewModel.allTasks.remove(atOffsets: offset)
        
        // Update the picker style based upon the count of all tasks in the task list
        taskViewModel.useSegmentedPickerStyle = categories.count > 6 ? false : true
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
    }
}

