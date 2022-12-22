//
//  BaseViewController.swift
//  SharePlanner
//
//  Created by Ayeon on 2022/12/22.
//

import Foundation
import RxSwift
import ReactorKit


enum TransitionType {
    static let defaultDimmColor = UIColor.black.withAlphaComponent(0.6)
    
    case push(enableGesturePop: Bool = false)
    case dimmPresent(from: PresentationDirection = .bottom, dimmColor: UIColor = TransitionType.defaultDimmColor)
    case present
    case tabBarPresent(dimmColor: UIColor = TransitionType.defaultDimmColor)
    case naviPresent(dimmColor: UIColor = TransitionType.defaultDimmColor)
}

enum PresentationDirection {
    case left
    case top
    case right
    case bottom
}

//MARK: - Bind Reactor Action And State
protocol BindReactorActionStateProtocol {
    associatedtype ReactorType
    
    func bindAction(_ reactor: ReactorType)
    func bindState(_ reactor: ReactorType)
}

extension BindReactorActionStateProtocol {
    func bind(reactor: ReactorType) {
        self.bindAction(reactor)
        self.bindState(reactor)
    }
}

//MARK: - View Protocol
protocol ConfigureViewProtocol {
    func configureLayout()
    func configureLayer()
}

typealias BaseViewController<T: Reactor> = BaseViewControllerClass<T> & BindReactorActionStateProtocol

class BaseViewControllerClass<T: Reactor>: UIViewController, ConfigureViewProtocol {
    typealias ReactorType = T
    
    var disposeBag = DisposeBag()
    
    var reactor: T!
    
    var transitionType: TransitionType?
    
    var state: T.State? {
        return self.reactor.currentState
    }
    
    deinit {
        log.deinitLog()
    }
    
    init(reactor: T) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        self.loadViewIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.configureLayer()
    }
    
    func configureLayout() {}
    
    func configureLayer() {}
}

