//
//  TaskView.swift
//  
//  Created by Manajit Halder on 09/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct TaskView: View {
    @StateObject private var taskViewModel = TaskViewModel()
    
    @State private var selectedCategory = "All"
//    @State private var isDrawerOpen = false
    @State private var isAddingTask = false
    @State private var alternateColor = false
    
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
//    @FocusState private var isSearchFieldFocussed: Bool
    
//    @State private var taskFilter: String = "category"
    
//    @State private var currentStatus = "In Progress"
    
    @EnvironmentObject var userSettings: SettingsViewModel
    
    @State private var status: String = "Not Started"
        
    enum filterType {
        case taskCategory
        case taskSchedule
        case taskStatus
        case none
    }
    
    enum filterStatus {
        case inProgress
        case completed
        case none
    }
    
    enum taskScheduleEnum {
        case today
        case upcoming
        case none
    }
    
    @State private var taskFilter: filterType = .none
    @State private var taskScheduleFilter: taskScheduleEnum = .none
    @State private var taskStatusFilter: filterStatus = .none
    
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
                return taskViewModel.allTasks.filter { $0.dueDate ==  todaysDate }
                
            case .upcoming:
                let todaysDate = DateUtils.dateToString(Date())
                return taskViewModel.allTasks.filter { $0.dueDate >  todaysDate }
            case .none:
                print("taskSchedule: none")
            }
            
        case .taskStatus:
            switch taskStatusFilter {
            case .inProgress:
                return taskViewModel.allTasks.filter { $0.status == "In Progress" }
            case .completed:
                print("taskStatusFilter: Completed")
            case .none:
                print("taskStatusFilter: none")
            }
        case .none:
            print("taskFilter: none")
        }
        
//        if selectedCategory == "All" {
//            return taskViewModel.allTasks
//        } else if selectedCategory == "In Progress" {
//            return taskViewModel.allTasks.filter { $0.status == selectedCategory }
//        } else if selectedCategory == "Today" {
////            print("dueDate: \($0.dueDate)")
//            let todaysDate = DateUtils.dateToString(Date())
//            print("todays date: \(todaysDate)")
//
////            let datess = dateFormatter.date(from: todaysDate)
//
//            return taskViewModel.allTasks.filter { $0.dueDate ==  todaysDate }
//        } else if selectedCategory == "Upcoming" {
//            print("Upcoming")
//            //            print("dueDate: \($0.dueDate)")
//            let todaysDate = DateUtils.dateToString(Date())
//            print("todays date: \(todaysDate)")
//
//            //            let datess = dateFormatter.date(from: todaysDate)
//
//            return taskViewModel.allTasks.filter { $0.dueDate >  todaysDate }
//        } else if selectedCategory == "Completed" {
//            return Array(taskViewModel.completedTasks)
//        } else {
//            return taskViewModel.allTasks.filter { $0.category == selectedCategory }
//        }
        return taskViewModel.allTasks
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
                                        taskViewModel.startTask(taskItem, status)
                                    } label: {
                                        Label("Start", systemImage: "play.fill")
                                        
                                    }
                                    
                                    Button {
                                        status = "Completed"
                                        taskViewModel.completeTask(taskItem, status)
                                        taskViewModel.addCompletedTask(taskItem)
                                        taskViewModel.deleteTask(taskItem)
                                    } label: {
                                        Label("Complete", systemImage: "c.square.fill")
                                    }
                                }
                            }
//                            .navigationTitle("")
                    }
//                    .navigationTitle(task.title)
                }
                .onDelete(perform: deleteTask)
                .listRowBackground(getListRowColor(alternateColor))
                
//                .navigationTitle("")
            }
            .searchable(text: $taskViewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search Task")
            
            HStack {
                if taskViewModel.useSegmentedPickerStyle {
//                    taskFilter = .taskCategory
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onAppear {
                        taskFilter = .taskCategory
                    }
//                    .onDisappear {
//                        taskFilter = .none
//                    }
                } else {
//                    taskFilter = .taskCategory
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    .onAppear {
                        taskFilter = .taskCategory
                    }
//                    .onDisappear {
//                        taskFilter = .none
//                    }
                }
            }
            .padding([.leading, .trailing], 20)
            .padding([.top, .bottom], 10)
            .background(Color.indigo.opacity(0.5))
            
            HStack {
                
//                ZStack {
//                    Menu(content: {
//                        Button {
//                            //
//                        } label: {
//                            Text("Upcoming").tag("Upcoming")
//                        }
//
//                        Button {
//                            selectedCategory = "Today"
//                        } label: {
//                            Text("Today").tag("Today")
//                        }
//
//                        Divider()
//
//                        Section("Status") {
//                            Button {
//                                selectedCategory = "Completed"
//                            } label: {
//                                Text("Completed").tag("Completed")
//                            }
//
//                            Button {
//                                selectedCategory = "In Progress"
//                            } label: {
//                                Text("In Progress").tag("In Progress")
//                            }
//                        }
//                    }, label: {
//                        Label("Menu", systemImage: "line.3.horizontal")
//                            .font(.custom("Cochin", size: 20))
//                            .foregroundColor(.black)
//                    })
//                    .padding(.leading, 20)
//                    .padding(.top, 30)
//                    .frame(width: 10, height: 15)
//                    .padding()
//                    .clipShape(Rectangle())
//                    .padding(.bottom, 20)
//                }
//                .padding()
                
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
                
//                NavigationStack {
////                    ZStack {
//                        Menu {
//
//                            NavigationLink {
//                                EmptyView()
//                            } label: {
//                                Text("Settings")
//                            }
//
//                            Divider()
//
//                            Button {
//                                //
//                            } label: {
//                                Text("item 3")
//                            }
//
//
//                        } label: {
//                            Label("Settings", systemImage: "gear")
//                                .font(.custom("Cochin", size: 20))
//                                .rotationEffect(.degrees(90))
//                                .foregroundColor(.black)
//                        }
////                        .padding(.trailing, 20)
////                        .padding(.top, 40)
////                        .frame(width: 10, height: 25)
////                        .padding()
////                        .clipShape(Rectangle())
////                        .padding(.bottom, 20)
////                    }
////                    .padding()
//                }
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
//                        selectedCategory = "Upcoming"
                    } label: {
                        Text("Upcoming").tag("Upcoming")
                    }
                    
                    Button {
                        taskFilter = .taskSchedule
                        taskScheduleFilter = .today
//                        selectedCategory = "Today"
                    } label: {
                        Text("Today").tag("Today")
                    }
                    
                    Divider()
                    
                    Section("Status") {
                        NavigationLink("Completed") {
//                            taskStatusFilter = .completed
                            
                            CompletedTaskView(taskViewModel: taskViewModel)
                        }
                        Button(action: {
                            NavigationLink("Completed") {
                                CompletedTaskView(taskViewModel: taskViewModel)
                            }
                        }, label: {
                            Text("In Progress").tag("In Progress")
                        })
//                        .onAppear {
//                            taskFilter = .taskStatus
//                            taskStatusFilter = .completed
//                        }
//                        .onDisappear {
//                            taskFilter = .taskCategory
//                            taskStatusFilter = .none
//                        }
//                        Button {
//                            selectedCategory = "Completed"
//
//                        } label: {
//                            Text("Completed").tag("Completed")
//                        }
                        
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
        return Color.black.opacity(0.03)
    }
    
    // Delete task at swipe from right to left.
    func deleteTask(at offset: IndexSet) {
        taskViewModel.allTasks.remove(atOffsets: offset)
        
        // Update the picker style based upon the count of all tasks in the task list
        taskViewModel.useSegmentedPickerStyle = $taskViewModel.allTasks.count > 5 ? false : true
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
    }
}

