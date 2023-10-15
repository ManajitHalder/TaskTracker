//
//  TaskListItemView.swift
//  
//  Created by Manajit Halder on 12/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct TaskListItemView: View {
    var task: Task
        
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.custom("Cochin", size: 20))
                    .padding(.bottom, 5)
                    .foregroundColor(.primary)
                
                Text("Priority: \t\(task.priority)")
                    .font(.custom("Cochin", size: 12))
                    .fontDesign(.rounded)
                    .foregroundColor(.secondary)
                
                Text("Status: \(task.status)")
                    .font(.custom("Cochin", size: 12))
                    .fontDesign(.rounded)
                    .foregroundColor(.secondary)
                
                Text("Category: \(task.category)")
                    .font(.custom("Cochin", size: 12))
                    .fontDesign(.rounded)
                    .foregroundColor(.secondary)
                
                Text("Due Date: \(formattedDate(task.dueDate))")
                    .font(.custom("Cochin", size: 12))
                    .fontDesign(.rounded)
                    .foregroundColor(.secondary)
            }
            .padding([.leading, .trailing], 20)
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
//        formatter.timeStyle = .short
        formatter.timeZone = .current
        formatter.calendar = .autoupdatingCurrent
        
        return formatter.string(from: date)
    }
}

struct TaskListItemView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListItemView(task: Task(title: "", description: "", dueDate: Date()))
    }
}
