//
//  CalendarRegisterReactor.swift
//  SharePlanner
//
//  Created by Ayeon on 2023/01/25.
//

import Foundation
import ReactorKit

class CalendarRegisterReactor: Reactor {
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        let ymd: YearMonth
    }
    
    let initialState: State
    
    init(ym: YearMonth) {
        initialState = State(ymd: ym)
    }
}
