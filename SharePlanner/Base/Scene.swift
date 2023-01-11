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
    case calendar(CalendarContentReactor)
    case sideMenu(SideMenuReactor)
    case setting(SettingReactor)
}

extension Scene {
    func instantiate() -> UIViewController {
        switch self {
        case .calendarContainer(let reactor):
            let vc = CalendarContainerVC(reactor: reactor)
            vc.bind(reactor: reactor)
            
            return vc
            
        case .calendar(let reactor):
            let vc = CalendarContentVC(reactor: reactor)
            vc.bind(reactor: reactor)
            
            return vc
            
        case .sideMenu(let reactor):
            let vc = SideMenuVC(reactor: reactor)
            vc.bind(reactor: reactor)
            
            return vc
            
        case .setting(let reactor):
            let vc = SettingVC(reactor: reactor)
            vc.bind(reactor: reactor)
            
            return vc
        }
    }
}
