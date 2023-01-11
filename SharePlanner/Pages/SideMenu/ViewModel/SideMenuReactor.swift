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
        case transformSideViewX(CGFloat)
        case transformToOriginal
        case noneAction
        case closeView
    }
    
    enum Mutation {
        case setCloseView(Bool)
        case setSideViewTranslateX(CGFloat?)
    }
    
    struct State {
        @Pulse var sideMenuList: [String] = ["setting1", "setting2", "setting3", "setting4"]
        var shouldClose: Bool = false
        @Pulse var sideViewTranslateX: CGFloat?
    }
    
    let initialState: State = State()
    
    init() {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .transformSideViewX(let x):
            return .just(.setSideViewTranslateX(x))
            
        case .transformToOriginal:
            return .just(.setSideViewTranslateX(0))
            
        case .closeView:
            return closeViewAction()
            
        case .noneAction:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSideViewTranslateX(let posX):
            newState.sideViewTranslateX = posX
            
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


