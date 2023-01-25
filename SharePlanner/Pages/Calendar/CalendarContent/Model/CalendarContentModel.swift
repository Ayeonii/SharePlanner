//
//  CalendarContentModel.swift
//  SharePlanner
//
//  Created by Ayeon on 2022/12/23.
//

import Foundation

struct YearMonth: Hashable {
    var year: Int
    var month: Month
    var day: Int = 1
    
    func getPrevYM() -> Self {
        var prevYear = self.year
        let prevMonth = self.month.getPrevMonth()
        if prevMonth == .dec {
            prevYear -= 1
        }
        
        let today = Date()
        if prevYear == today.year, prevMonth == today.monthType {
            return YearMonth(year: prevYear, month: prevMonth, day: today.day)
        }
        
        return YearMonth(year: prevYear, month: prevMonth, day: 1)
    }
    
    func getNextYM() -> Self {
        var nextYear = self.year
        let nextMonth = self.month.getNextMonth()
        if nextMonth == .jan {
            nextYear += 1
        }
        
        let today = Date()
        if nextYear == today.year, nextMonth == today.monthType {
            return YearMonth(year: nextYear, month: nextMonth, day: today.day)
        }
        
        return YearMonth(year: nextYear, month: nextMonth, day: 1)
    }
    
    func getDateToString() -> String {
        return "\(year)-\(month.rawValue)-\(day)"
    }
}

extension YearMonth {
    init(date: Date) {
        self.init(year: date.year, month: date.monthType, day: date.day)
    }
    
    init(ym: YearMonth, day: Int) {
        self.init(year: ym.year, month: ym.month, day: ym.day)
    }
}
