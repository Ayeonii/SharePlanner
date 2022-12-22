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
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    var initialState: State = State()
    
    init() {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        }
        
        return newState
    }
}
