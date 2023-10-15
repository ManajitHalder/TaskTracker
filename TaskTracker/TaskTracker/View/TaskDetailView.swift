//
//  TaskDetailView.swift
//  
//  Created by Manajit Halder on 12/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    
//    @State private var title: String = ""
//    @State private var description: String = ""
//    @State private var category: String = "Personal"
//    @State private var priority: String = "High"
//    @State private var dueDate: Date = Date()
//
//    var task: Task
    
    var body: some View {
        Text(taskViewModel.tasks[0].title)
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(taskViewModel: TaskViewModel())
    }
}
