//
//  Validator+TN.swift
//  TNHelperSwift
//
//  Created by Nallamothu Tharun Kumar on 6/24/19.
//  Copyright © 2019 ATT CDO. All rights reserved.
//

import Foundation

extension Date {
    func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: 0), to: self.startOfMonth())!
    }
    
    func justDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"//never change this format unless required. Changing this needs to rework on this method
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dateFormatter.string(from: self)
        //separate the dateString into multiple Components so that we can extract what we need
        return dateString.components(separatedBy: " ").first
    }
    
    func getMonthYear() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL yyyy"
        return dateFormatter.string(from: self)
    }
    
    func numberOfHours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    func getDateTimeString() -> String? {
        let parkingDateFormatter = DateFormatter()
        let monthDayFormatString = DateFormatter.dateFormat(fromTemplate: "MMM-d", options: 0, locale: Locale.current)
        parkingDateFormatter.dateFormat = monthDayFormatString
        
        let monthAndDay = parkingDateFormatter.string(from: self)
        
        let timeFormatString = DateFormatter.dateFormat(fromTemplate: "h:mm", options: 0, locale: Locale.current)
        parkingDateFormatter.dateFormat = timeFormatString
        let time = parkingDateFormatter.string(from: self).lowercased()
        
        return "\(monthAndDay) \(time)"
    }
}

