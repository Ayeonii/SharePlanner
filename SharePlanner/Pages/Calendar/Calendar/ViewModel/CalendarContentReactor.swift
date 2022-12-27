//
//  CalendarReactor.swift
//  SharePlanner
//
//  Created by Ayeon on 2022/12/22.
//

import Foundation
import RxSwift
import ReactorKit

class CalendarContentReactor: Reactor {
    var disposeBag = DisposeBag()
    
    enum Action {
        case setYearMonth(YearMonth)
        case showAlert
    }
    
    enum Mutation {
        case setYearMonth(YearMonth)
        case setAlertMsg(String?)
    }
    
    struct State {
        @Pulse var yearMonth: YearMonth
        var showAlertWithMsg: String?
    }
    
    let initialState: State
    
    init(yearMonth: YearMonth) {
        initialState = State(yearMonth: yearMonth)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setYearMonth(let yearMonth):
            return .just(.setYearMonth(yearMonth))
            
        case .showAlert:
            return .concat([
                .just(.setAlertMsg("Test!!")),
                .just(.setAlertMsg(nil))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setYearMonth(let ym):
            newState.yearMonth = ym
            
        case .setAlertMsg(let msg):
            newState.showAlertWithMsg = msg
        }
        
        return newState
    }
}
