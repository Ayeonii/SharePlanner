//
//  Scene.swift
//  SharePlanner
//
//  Created by Ayeon on 2022/12/22.
//

import Foundation
import UIKit

enum Scene {
    case calendar(CalendarReactor)
}

extension Scene {
    func instantiate() -> UIViewController {
        switch self {
        case .calendar(let reactor):
            let vc = CalendarViewController(reactor: reactor)
            vc.bind(reactor: reactor)
            
            return vc
        }
    }
}
