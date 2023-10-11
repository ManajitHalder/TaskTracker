//
//  TaskView.swift
//  
//  Created by Manajit Halder on 09/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct TaskView: View {
    @ObservedObject private var taskList = TaskViewModel()
    @State private var selectedCategory = "All"
    @State private var isDrawerOpen = false
    
    @State private var isAddingTask = false

    var categories: [String] {
        var uniqueCategories = Set<String>()
        print(taskList.tasks.count)
        
        taskList.tasks.forEach { task in
            uniqueCategories.insert(task.category)
        }
        return Array(uniqueCategories) + ["All"]
    }

    var filteredTasks: [Task] {
        if selectedCategory == "All" {
            return taskList.tasks
        } else {
            return taskList.tasks.filter { $0.category == selectedCategory }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
                
            Picker("Select Category", selection: $selectedCategory) {
                ForEach(categories, id: \.self) { category in
                    Text(category)
                        .foregroundColor(.black)
                }
            }
            .pickerStyle(MenuPickerStyle()) // Use MenuPickerStyle to make it look like a dropdown menu
            
            ScrollView {
                ForEach(filteredTasks, id: \.self) { task in
                    TaskListItemView(title: task.title)
                        .padding()
                }
            }
            
            Spacer()
            
            HStack {
                Spacer()
                
                ZStack {
                    Circle() // Outer circle (larger)
                        .padding(.bottom, 20)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                    
                    Button(action: {
                        isAddingTask.toggle()
                    }) {
                        NavigationLink(destination: TaskAddView(taskList: taskList)) {
                            Image(systemName: "plus")
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        }
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
        .navigationBarHidden(true)
    }
}



struct TaskListItemView: View {
    @State var isEditingTask = false
    var title: String
    
    var body: some View {
        GeometryReader { geometry in
            NavigationLink(destination: EditTaskView(title: title)) {
                VStack(spacing: 20) {
                    Button {
                        isEditingTask.toggle()
                    } label: {
                        NavigationLink(destination: EditTaskView(title: title)) {
                            Text(title)
                                .font(.custom("Cochin", size: 18))
                                .fontDesign(.rounded)
                                .multilineTextAlignment(.leading)
                                .lineLimit(20)
                                .foregroundColor(.black)
                                .background(.blue)
                                .padding()
                        }
                    }
                }
                .frame(width: geometry.size.width * 0.9, height: 120)
                .background(.green)
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .circular)
                        .stroke(Color.black.opacity(0.8), lineWidth: 2)
                )
                .background(.blue)
                
            }
            .background(.yellow)
            .padding([.leading, .trailing], 10)
        }
        .padding(.bottom, 100)
    }
    
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
    }
}

struct EditTaskView: View {
    var title: String
    
    var body: some View {
        Text(title)
    }
}


