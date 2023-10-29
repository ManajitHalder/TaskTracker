//
//  CompletedTaskView.swift
//  
//  Created by Manajit Halder on 29/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct CompletedTaskView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            List {
                ForEach(Array(taskViewModel.completedTasks), id: \.self) { task in
                    TaskStaticView(task: task)
                }
                .listStyle(.sidebar)
            }
        }
        .navigationTitle("Completed Tasks")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: {
                    // Go back to previous screen
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                })
                .padding(.leading, 10)
            )
    }
}

struct CompletedTaskView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedTaskView(taskViewModel: TaskViewModel())
    }
}
