//
//  CalendarContainerReactor.swift
//  SharePlanner
//
//  Created by Ayeon on 2022/12/22.
//

import Foundation
import RxSwift
import ReactorKit

class CalendarContainerReactor: Reactor {
    let disposeBag = DisposeBag()
   
    enum Action {
        case changeCurrentYM(YearMonth)
    }
    
    enum Mutation {
        case setCurrentYM(YearMonth)
    }
    
    struct State {
        var currentYM: YearMonth
    }
    
    var initialState: State
    
    init() {
        let currentDate =  Date()
        initialState = State(currentYM: YearMonth(year: currentDate.year, month: currentDate.monthType))
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .changeCurrentYM(let ym):
            return .just(.setCurrentYM(ym))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setCurrentYM(let ym):
            newState.currentYM = ym
        }
        
        return newState
    }
}
