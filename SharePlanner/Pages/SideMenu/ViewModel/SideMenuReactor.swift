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
        case showSetting
        case closeView
        case noneAction
    }
    
    enum Mutation {
        case setSideViewTranslateX(CGFloat?)
        case setShowSetting(Bool)
        case setCloseView(Bool)
    }
    
    struct State {
        @Pulse var sideMenuList: [String] = ["setting1", "setting2", "setting3", "setting4"]
        @Pulse var sideViewTranslateX: CGFloat?
        var shouldShowSetting: Bool = false
        var shouldClose: Bool = false
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
            
        case .showSetting:
            return showSettingAction()
            
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
            
        case .setShowSetting(let shouldShow):
            newState.shouldShowSetting = shouldShow
        }
        
        return newState
    }
}

extension SideMenuReactor {
    func showSettingAction() -> Observable<Mutation> {
        return .concat([
            .just(.setShowSetting(true)),
            .just(.setShowSetting(false))
        ])
    }
    
    func closeViewAction() -> Observable<Mutation> {
        return .concat([
            .just(.setCloseView(true)),
            .just(.setCloseView(false))
        ])
    }
}


