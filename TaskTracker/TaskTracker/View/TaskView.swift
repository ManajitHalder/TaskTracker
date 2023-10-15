//
//  TaskView.swift
//  
//  Created by Manajit Halder on 09/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct TaskView: View {
    @StateObject private var taskViewModel = TaskViewModel()
    
    @State private var selectedCategory = "All Tasks"
    @State private var isDrawerOpen = false
    @State private var isAddingTask = false
    @State private var alternateColor = false
    
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @FocusState private var isSearchFieldFocussed: Bool
    
    @State private var taskFilter: String = "category"
    
    var categories: [String] {
        var uniqueCategories = Set<String>()
        
        taskViewModel.tasks.forEach { task in
            uniqueCategories.insert(task.category)
        }
        
        return Array(uniqueCategories) + ["All Tasks"]
    }

    var filteredTasks: [Task] {
        if selectedCategory == "All Tasks" {
            return taskViewModel.tasks
        } else {
            return taskViewModel.tasks.filter { $0.category == selectedCategory }
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
                
            HStack {
                Text("Filter by \(taskFilter):")
                    .padding(.leading, 10)
                
                Picker("Select Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                            .foregroundColor(.black)
                    }
                }
                .pickerStyle(MenuPickerStyle()) // Use MenuPickerStyle to make it look like a dropdown menu
            }
            
            List {
                ForEach(filteredTasks, id: \.self) { task in
                    NavigationLink(destination: TaskDetailView(taskViewModel: taskViewModel)) {
                        TaskListItemView(task: task)
                    }
                }
                .listRowBackground(getListRowColor(alternateColor))
            }
            
            Spacer()
            
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
//                        .navigationBarTitle("Task Tracker", displayMode: .inline)
                        .navigationTitle("")
                        .navigationBarItems(
                            leading: HStack {
                                Button(action: {
                                    withAnimation {
                                        isSearching = true
                                        isSearchFieldFocussed = true
                                        searchText = ""
                                    }
                                }) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.custom("Cochin", size: 15))
                                }
                                if isSearching {
                                    TextField("Search Task", text: $searchText)
//                                        .background(Color(.systemGray5))
                                        .cornerRadius(8)
                                        .frame(height: 30)
                                        .focused($isSearchFieldFocussed)
                                }
                            },
                            trailing: HStack {
                                if isSearching {
                                    Button {
                                        withAnimation {
                                            isSearching = false
                                            isSearchFieldFocussed = false
                                            searchText = ""
                                        }
                                    } label: {
                                        Image(systemName: "xmark")
                                            .font(.custom("Cochin", size: 15))
                                    }
                                } else {
                                    Button(action: {
                                        // Handle the search action
                                    }) {
                                        Image(systemName: "gearshape")
                                            .font(.custom("Cochin", size: 15))
                                    }
                                }
                            }
                        )
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
    }
    
    func getListRowColor(_ color: Bool) -> Color {
        return Color.black.opacity(0.03)
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
    }
}

