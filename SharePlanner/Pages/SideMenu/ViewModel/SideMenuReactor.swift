//
//  SideMenuReactor.swift
//  SharePlanner
//
//  Created by 이아연 on 2022/12/28.
//

import Foundation
import ReactorKit

class SideMenuReactor: Reactor {
    enum Action {
        case closeView
    }
    
    enum Mutation {
        case setCloseView(Bool)
    }
    
    struct State {
        var shouldClose: Bool = false
    }
    
    let initialState: State = State()
    
    init() {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .closeView:
            return closeViewAction()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setCloseView(let shouldClose):
            newState.shouldClose = shouldClose
        }
        
        return newState
    }
}

extension SideMenuReactor {
    func closeViewAction() -> Observable<Mutation> {
        return .concat([
            .just(.setCloseView(true)),
            .just(.setCloseView(false))
        ])
    }
}


