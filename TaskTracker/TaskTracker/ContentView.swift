//
//  ContentView.swift
//  
//  Created by Manajit Halder on 09/10/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct ContentView: View {
    @State private var selectedCategory = "All"
    @State private var isMenuOpen = false
    
    var filteredTasks: [TaskCategories] {
        if selectedCategory == "All" {
            return tasks
        } else {
            return tasks.filter { $0.category == selectedCategory }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
                
            Picker("Selected Category", selection: $selectedCategory) {
                Text("All").tag("All")
                Text("Personal").tag("Personal")
                Text("Word").tag("Work")
                Text("Wishlist").tag("Wishlist")
                Text("Shopping").tag("Shopping")
                Text("Critical").tag("Critical")
                Text("Hobby").tag("Hobby")
            }
            .pickerStyle(.automatic)
            
            List(filteredTasks) { task in
                Text(task.title)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
