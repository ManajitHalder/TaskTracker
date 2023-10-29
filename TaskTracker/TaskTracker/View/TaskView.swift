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
        if selectedCategory == "All" {
            return taskViewModel.allTasks
        } else if selectedCategory == "In Progress" {
            return taskViewModel.allTasks.filter { $0.status == selectedCategory }
        } else if selectedCategory == "Today" {
            print("Today ")
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            let currentDate = Date()
            let todaysDate = dateFormatter.string(from: currentDate)
            
            let datess = dateFormatter.date(from: todaysDate)
            
//            let dateToday = dateFormatter.string(from: )
            print(todaysDate)
            print(datess!)
            
            return taskViewModel.allTasks.filter { $0.dueDate == datess }
        } else if selectedCategory == "Completed" {
            return Array(taskViewModel.completedTasks)
        } else {
            return taskViewModel.allTasks.filter { $0.category == selectedCategory }
        }
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
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)
                } else {
                    Picker("Select Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
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
                        //
                    } label: {
                        Text("Upcoming").tag("Upcoming")
                    }
                    
                    Button {
                        selectedCategory = "Today"
                    } label: {
                        Text("Today").tag("Today")
                    }
                    
                    Divider()
                    
                    Section("Status") {
                        NavigationLink("Completed") {
                            CompletedTaskView(taskViewModel: taskViewModel)
                        }
//                        Button {
//                            selectedCategory = "Completed"
//
//                        } label: {
//                            Text("Completed").tag("Completed")
//                        }
                        
                        Button {
                            selectedCategory = "In Progress"
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

