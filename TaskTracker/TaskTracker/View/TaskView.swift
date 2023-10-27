//
//  TaskView.swift
//  
//  Created by Manajit Halder on 09/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct TaskView: View {
    @StateObject private var taskViewModel = TaskViewModel()
    
    @State private var selectedCategory = "All"
    @State private var isDrawerOpen = false
    @State private var isAddingTask = false
    @State private var alternateColor = false
    
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @FocusState private var isSearchFieldFocussed: Bool
    
    @State private var taskFilter: String = "category"
        
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
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            List {
                ForEach(taskViewModel.isSearching ? taskViewModel.filteredTasks : self.filteredTasks, id: \.self) { taskItem in
                    NavigationLink(destination: TaskDetailView(taskViewModel: taskViewModel, task: taskItem)) {
                        TaskListItemView(task: taskItem)
                    }
//                    .navigationTitle(task.title)
                }
                .onDelete(perform: deleteTask)
                .listRowBackground(getListRowColor(alternateColor))
            }
            .searchable(text: $taskViewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search Task")
            .navigationBarItems(
                trailing:
                    Button {
//                        NavigationLink(destination: TaskListItemView(task: TaskItem(title: "tt", description: "dd", dueDate: Date()))) {
//                            TaskListItemView(task: TaskItem(title: "tt", description: "dd", dueDate: Date()))
                        //
//                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .font(.custom("Cochin", size: 15))
                            .contextMenu {
                                Button {
                                    //
                                } label: {
                                    Text("item 1")
                                }

                                Button {
                                    //
                                } label: {
                                    Text("item 2")
                                }
                                
                                Button {
                                    //
                                } label: {
                                    Text("item 3")
                                }
                                
                                NavigationLink(destination: SettingsView(), label: {
                                    Text("Settings")
                                })
                            }
                            .menuStyle(.button)
                    }
            )
//            .task {
//                taskViewModel.loadTasks()
//            }
//            .onAppear {
//                taskViewModel.loadTasks()
//            }
            
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
                Button {
                    //
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .frame(width: 30, height: 30)
//                        .foregroundColor(.white)
                }

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
                
                Text("End")
                    .padding(.leading, 40)
                    .padding(.trailing)
            }
            .frame(maxHeight: 40)
            .background(.bar)
        }
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

