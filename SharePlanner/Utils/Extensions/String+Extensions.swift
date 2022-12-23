//
//  String+Extensions.swift
//  SharePlanner
//
//  Created by Ayeon on 2022/12/23.
//

import Foundation

extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
