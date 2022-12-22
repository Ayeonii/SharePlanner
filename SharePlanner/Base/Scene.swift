//
//  Scene.swift
//  SharePlanner
//
//  Created by Ayeon on 2022/12/22.
//

import Foundation
import UIKit

enum Scene {
    case calendarContainer(CalendarContainerReactor)
    case calendar(CalendarReactor)
}

extension Scene {
    func instantiate() -> UIViewController {
        switch self {
        case .calendarContainer(let reactor):
            let vc = CalendarContainerVC(reactor: reactor)
            vc.bind(reactor: reactor)
            
            return vc
            
        case .calendar(let reactor):
            let vc = CalendarVC(reactor: reactor)
            vc.bind(reactor: reactor)
            
            return vc
        }
    }
}
