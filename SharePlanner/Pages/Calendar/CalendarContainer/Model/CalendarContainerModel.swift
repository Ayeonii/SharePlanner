//
//  CalendarContainerModel.swift
//  SharePlanner
//
//  Created by Ayeon on 2022/12/23.
//

import UIKit

enum Month: Int {
    case jan = 1
    case fab = 2
    case mar = 3
    case apr = 4
    case may = 5
    case jun = 6
    case jul = 7
    case aug = 8
    case sep = 9
    case oct = 10
    case nov = 11
    case dec = 12
    
    func getEngName() -> String {
        switch self {
        case .jan:
            return "JANUARY"
        case .fab:
            return "FABRUARY"
        case .mar:
            return "MARCH"
        case .apr:
            return "APRIL"
        case .may:
            return "MAY"
        case .jun:
            return "JUNE"
        case .jul:
            return "JULY"
        case .aug:
            return "AUGUST"
        case .sep:
            return "SEPTEMBER"
        case .oct:
            return "OCTOBER"
        case .nov:
            return "NOVEMBER"
        case .dec:
            return "DECEMBER"
        }
    }
    
    func getNumberOfDays() -> Int {
        switch self {
        case .jan:
            return 31
        case .fab:
            return 28
        case .mar:
            return 31
        case .apr:
            return 30
        case .may:
            return 31
        case .jun:
            return 30
        case .jul:
            return 31
        case .aug:
            return 31
        case .sep:
            return 30
        case .oct:
            return 31
        case .nov:
            return 30
        case .dec:
            return 31
        }
    }
}

enum Weekday: String {
    case sun = "일"
    case mon = "월"
    case tue = "화"
    case wed = "수"
    case thu = "목"
    case fri = "금"
    case sat = "토"
    
    func getTextColor() -> UIColor {
        switch self {
        case .sun:
            return .appColor(.rosePink)
        case .sat:
            return .appColor(.blue)
        default:
            return .appColor(.textPrimary)
        }
    }
}
