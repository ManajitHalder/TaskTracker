//
//  ContentView.swift
//  
//  Created by Manajit Halder on 09/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct TaskView: View {
    @StateObject private var taskList = TaskViewModel()
    @State private var selectedCategory = "All"
    @State private var isDrawerOpen = false
    
    @State private var isAddingTask = false

    var categories: [String] {
        var uniqueCategories = Set<String>()
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
        
        NavigationView {
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
                            NavigationLink(destination: TaskAddView()) {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 20, height: 20)
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
}

struct TaskAddView: View {
    var body: some View {
        Text("Add Task View")
            .background(Color.pink) // Add background color if needed
    }
}

struct TaskListItemView: View {
     var title: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Text(title)
                    .font(.custom("Cochin", size: 18))
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.leading)
                    .lineLimit(20)
                    .foregroundColor(.black)
                    .background(.white)
            }
            .frame(width: geometry.size.width * 0.9, height: 80)
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .circular)
                    .stroke(Color.black.opacity(0.5), lineWidth: 2)
            )
            .padding([.leading, .trailing], 10)
        }
        .padding(.bottom, 40)
    }
    
    private func calculateMinHeight(for text: String, in size: CGSize) -> CGFloat {
        let textHeight = text.height(withConstrainedWidth: size.width * 0.9, font: UIFont(name: "Cochin", size: 18) ?? UIFont.systemFont(ofSize: 18))
        return max(textHeight + 20, 30) // Ensure a minimum height of 30
    }
    
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
    }
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )

        return ceil(boundingBox.height)
    }
}

