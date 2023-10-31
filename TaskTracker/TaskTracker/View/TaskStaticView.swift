//
//  TaskStaticView.swift
//  
//  Created by Manajit Halder on 29/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct TaskStaticView: View {
    var task: TaskItem
    
    var body: some View {
        Section {
            VStack {
                HStack {
                    Text(task.title)
                        .foregroundColor(Color.purple)
                        .font(.custom("Cochin", size: 20))
                        .padding([.leading, .trailing], 10)
                        .multilineTextAlignment(.leading)
                }
                
                Divider()
                
                HStack {
                    VStack {
                        Text("DESCRIPTION")
                            .foregroundColor(Color.gray)
                            .font(.custom("Cochin", size: 10))
                        
                        Divider()
                        ScrollView(showsIndicators: true) {
                            Text(task.description)
                                .foregroundColor(.black)
                                .font(.custom("Cochin", size: 17))
                                .padding([.leading, .trailing], 10)
                                .multilineTextAlignment(.leading)
                                .frame(maxHeight: 500)
                        }
                    }
                }
                
                Divider()
                
                HStack() {
                    VStack {
                        Text("CATEGORY")
                            .foregroundColor(.gray)
                            .font(.custom("Cochin", size: 10))
                            .multilineTextAlignment(.leading)
                        
                        Divider()
                        
                        Text(task.category)
                            .foregroundColor(.black)
                            .font(.custom("Cochin", size: 15))
                    }
                    
                    Divider()
                    
                    VStack {
                        Text("PRIORITY")
                            .foregroundColor(.gray)
                            .font(.custom("Cochin", size: 10))
                        
                        Divider()
                        
                        Text(task.priority)
                            .foregroundColor(.black)
                            .font(.custom("Cochin", size: 15))
                    }
                    
                    Divider()
                    
                    VStack {
                        Text("STATUS")
                            .foregroundColor(.gray)
                            .font(.custom("Cochin", size: 10))
                        
                        Divider()
                        
                        Text(task.status)
                            .foregroundColor(.black)
                            .font(.custom("Cochin", size: 15))
                    }
                }
                .foregroundColor(.green.opacity(0.5))
                .font(.custom("Cochin", size: 15))
                
                Divider()
                
                HStack() {
                    VStack {
                        Text("START DATE")
                            .foregroundColor(.gray)
                            .font(.custom("Cochin", size: 10))
                            .multilineTextAlignment(.leading)
                        
                        Divider()
                        
                        Text(task.dueDate)
                            .foregroundColor(.black)
                            .font(.custom("Cochin", size: 15))
                    }
                    
                    Divider()
                    
                    VStack {
                        Text("DUE DATE")
                            .foregroundColor(.gray)
                            .font(.custom("Cochin", size: 10))
                        
                        Divider()
                        
                        Text(task.dueDate)
                            .foregroundColor(.black)
                            .font(.custom("Cochin", size: 15))
                    }
                    
                    Divider()
                    
                    VStack {
                        Text("FINISH DATE")
                            .foregroundColor(.gray)
                            .font(.custom("Cochin", size: 10))
                        
                        Divider()
                        
                        Text(task.dueDate)
                            .foregroundColor(.black)
                            .font(.custom("Cochin", size: 15))
                    }
                }
                .foregroundColor(.green.opacity(0.5))
                .font(.custom("Cochin", size: 15))
            }

            DisclosureGroup("UPDATES") {
                ForEach(task.updates.reversed()) { update in
                    Text(update.text)
                        .foregroundColor(Color.black)
                        .font(.custom("Cochin", size: 13))
                }
            }
            .foregroundColor(.gray)
            .font(.custom("Cochin", size: 10))
        }
        .listSectionSeparatorTint(.red)
        .listSectionSeparator(.visible)
    }
}

struct TaskStaticView_Previews: PreviewProvider {
    static var previews: some View {
        TaskStaticView(task: TaskItem())
    }
}
