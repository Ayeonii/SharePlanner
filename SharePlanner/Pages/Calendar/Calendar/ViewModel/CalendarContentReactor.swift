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
        case showAlert
    }
    
    enum Mutation {
        case setAlertMsg(String?)
    }
    
    struct State {
        var showAlertWithMsg: String?
    }
    
    let initialState = State()
    
    init() {
        log.debug("init!")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
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
        case .setAlertMsg(let msg):
            newState.showAlertWithMsg = msg
        }
        
        return newState
    }
}
