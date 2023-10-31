//
//  DateConversions.swift
//  
//  Created by Manajit Halder on 30/10/23 using Swift 5.0 on MacOS 13.4
//  

import Foundation

struct DateUtils {
    
    static func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMM dd"
        let datestr = formatter.string(from: date)
        
        return datestr
    }
    
    static func stringToDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = formatter.date(from: dateString) {
            return date
        } else {
            return Date()
        }
    }
    
    static func areEqualDates(_ firstDate: Date, secondDate: Date) -> Bool {
        if firstDate == secondDate {
            return true
        } else {
            return false
        }
    }
    
}
