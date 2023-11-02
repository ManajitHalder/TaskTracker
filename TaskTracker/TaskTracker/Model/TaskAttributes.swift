//
//  TaskAttributes.swift
//  
//  Created by Manajit Halder on 02/11/23 using Swift 5.0 on MacOS 13.4
//  

import Foundation

enum TaskCategory: String, CaseIterable {
    case personal
    case study
    case work
    case wellness
    case travel
    case entertainment
    case shopping
    case hobby
    case wishlist
    case household
    
    func name() -> String {
        switch self {
        case .personal:
            return "Personal"
        case .study:
            return "Study"
        case .work:
            return "Work"
        case .wellness:
            return "Wellness"
        case .travel:
            return "Travel"
        case .entertainment:
            return "Entertainment"
        case .shopping:
            return "Shopping"
        case .hobby:
            return "Hobby"
        case .wishlist:
            return "Wishlist"
        case .household:
            return "Household"
        }
    }
}

enum TaskPriority: String, CaseIterable {
    case high
    case medium
    case low
    case urgent
    case routine
    case cirtical
    
    func name() -> String {
        switch self {
        case .high:
            return "High"
        case .medium:
            return "Medium"
        case .low:
            return "Low"
        case .urgent:
            return "Urgent"
        case .routine:
            return "Routine"
        case .cirtical:
            return "Critical"
        }
    }
}

enum TaskStatus: String, CaseIterable {
    case notStarted
    case inProgress
    case completed
    case cancelled
    case deferred
    case overdue
    
    func name() -> String {
        switch self {
        case .notStarted:
            return "Not Started"
        case .inProgress:
            return "In Progress"
        case .completed:
            return "Completed"
        case .cancelled:
            return "Cancelled"
        case .deferred:
            return "Deferred"
        case .overdue:
            return "Overdue"
        }
    }
}
