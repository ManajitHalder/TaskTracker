//
//  TaskCategories.swift
//  
//  Created by Manajit Halder on 09/10/23 using Swift 5.0 on MacOS 13.4
//  

import Foundation

struct Task: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var category: String
}




