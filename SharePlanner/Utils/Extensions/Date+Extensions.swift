//
//  Date+Extensions.swift
//  SharePlanner
//
//  Created by Ayeon on 2022/12/23.
//

import Foundation

extension Date {
    var weekday: Int {
        get {
            Calendar.current.component(.weekday, from: self)
        }
    }
    
    var firstDayOfTheMonth: Date {
        get {
            Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        }
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var monthType: Month {
        let monthNum = Calendar.current.component(.month, from: self)
        
        return Month(rawValue: monthNum) ?? .jan
    }
}
