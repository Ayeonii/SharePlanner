//
//  CalendarContentModel.swift
//  SharePlanner
//
//  Created by Ayeon on 2022/12/23.
//

import Foundation

struct YearMonth {
    var year: Int
    var month: Month
    
    func getPrevYM() -> Self {
        var prevYear = self.year
        let prevMonth = self.month.getPrevMonth()
        if prevMonth == .dec {
            prevYear -= 1
        }
        
        return YearMonth(year: prevYear, month: prevMonth)
    }
    
    func getNextYM() -> Self {
        var nextYear = self.year
        let nextMonth = self.month.getNextMonth()
        if nextMonth == .jan {
            nextYear += 1
        }
        
        return YearMonth(year: nextYear, month: nextMonth)
    }
}
