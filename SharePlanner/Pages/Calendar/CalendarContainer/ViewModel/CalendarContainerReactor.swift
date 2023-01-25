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
    enum Action: Equatable {
        case changeCurrentYM(YearMonth)
        case showSideMenu
        case showRegister(YearMonth)
    }
    
    enum Mutation {
        case setCurrentYM(YearMonth)
        case setShowSideMenu(Bool)
        case setShowRegister(YearMonth?)
    }
    
    struct State {
        var currentYM: YearMonth
        var shouldShowSideMenu: Bool = false
        var registerDate: YearMonth?
    }
    
    var initialState: State
    
    init() {
        let currentDate = Date()
        initialState = State(currentYM: YearMonth(date: currentDate))
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .changeCurrentYM(let ym):
            return .just(.setCurrentYM(ym))
            
        case .showSideMenu:
            return showSideMenuAction()
            
        case .showRegister(let date):
            return showRegisterAction(date: date)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setCurrentYM(let ym):
            newState.currentYM = ym
            
        case .setShowSideMenu(let shouldShow):
            newState.shouldShowSideMenu = shouldShow
            
        case .setShowRegister(let date):
            newState.registerDate = date
        }
        
        return newState
    }
}

extension CalendarContainerReactor {
    func showSideMenuAction() -> Observable<Mutation> {
        return .concat([
            .just(.setShowSideMenu(true)),
            .just(.setShowSideMenu(false))
        ])
    }
    
    func showRegisterAction(date: YearMonth) -> Observable<Mutation> {
        return .concat([
            .just(.setShowRegister(date)),
            .just(.setShowRegister(nil))
        ])
    }
}
