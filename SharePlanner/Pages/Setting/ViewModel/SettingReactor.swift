//
//  SettingReactor.swift
//  SharePlanner
//
//  Created by 이아연 on 2023/01/11.
//

import Foundation
import ReactorKit

class SettingReactor: Reactor {
    enum Action {
        case closeView
    }
    
    enum Mutation {
        case setCloseView(Bool)
    }
    
    struct State {
        @Pulse var settingMenuList: [String] = ["알림설정",
                                                "버전정보",
                                                "방 연결",
                                                "방 관리",
                                                "방 나가기",
                                                "로그아웃",
                                                "이용약관",
                                                "개인정보처리방침"]
        
        var shouldCloseView: Bool = false
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .closeView:
            return closeAction()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setCloseView(let shouldClose):
            newState.shouldCloseView = shouldClose
            
        }
        
        return newState
    }
}

extension SettingReactor {
    func closeAction() -> Observable<Mutation> {
        return .concat([
            .just(.setCloseView(true)),
            .just(.setCloseView(false))
        ])
    }
}
