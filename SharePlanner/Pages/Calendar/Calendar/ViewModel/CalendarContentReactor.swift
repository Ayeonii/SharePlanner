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
        case setSelectDefault
        case deselectCell
        case showAlert
    }
    
    enum Mutation {
        case setYearMonth(YearMonth)
        case setUpdateDefaultSelect(Bool?)
        case setAlertMsg(String?)
    }
    
    struct State {
        @Pulse var yearMonth: YearMonth
        var shouldUpdateDefaultSelect: Bool?
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
            
        case .setSelectDefault:
            return .concat([
                .just(.setUpdateDefaultSelect(true)),
                .just(.setUpdateDefaultSelect(nil))
            ])
            
        case .deselectCell:
            return .concat([
                .just(.setUpdateDefaultSelect(false)),
                .just(.setUpdateDefaultSelect(nil))
            ])
            
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
            
        case .setUpdateDefaultSelect(let shouldUpdate):
            newState.shouldUpdateDefaultSelect = shouldUpdate
            
        case .setAlertMsg(let msg):
            newState.showAlertWithMsg = msg
       
        }
        
        return newState
    }
}
