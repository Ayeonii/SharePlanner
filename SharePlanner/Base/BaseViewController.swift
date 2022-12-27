//
//  BaseViewController.swift
//  SharePlanner
//
//  Created by Ayeon on 2022/12/22.
//

import Foundation
import RxSwift
import ReactorKit

//MARK: - TransitionType
enum TransitionType {
    static let defaultDimmColor = UIColor.black.withAlphaComponent(0.6)
    
    case push(enableGesturePop: Bool = false)
    case dimmPresent(from: PresentationDirection = .bottom, dimmColor: UIColor = TransitionType.defaultDimmColor)
    case present
    case presentNavigation(dimmColor: UIColor = TransitionType.defaultDimmColor)
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


// MARK: - SuperClass of Common ViewControllers
typealias BaseViewController<T: Reactor> = BaseViewControllerClass<T> & BindReactorActionStateProtocol

class BaseViewControllerClass<T: Reactor>: UIViewController, ConfigureViewProtocol {
    typealias ReactorType = T
    
    lazy var dimmTransitionDelegate = DimmPresentManager()
    
    var disposeBag = DisposeBag()
    
    var reactor: T!
    
    var transitionType: TransitionType?
    
    var state: T.State {
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

extension BaseViewControllerClass {
    ///Move To Scene
    func transition(to scene: Scene, using style: TransitionType, animated: Bool, completion: (() -> Void)? = nil) {
        let target = scene.instantiate()
        self.moveToTarget(to: target, using: style, animated: animated, completion: completion)
    }
    
    ///Move To ViewController
    func transition(to vc: UIViewController, using style: TransitionType, animated: Bool, completion: (() -> Void)? = nil) {
        self.moveToTarget(to: vc, using: style, animated: animated, completion: completion)
    }
    
    ///Move Action
    func moveToTarget(to vc: UIViewController, using style: TransitionType, animated: Bool, completion: (() -> Void)? = nil) {
        let target = vc
        
        if var baseVC = target as? Self {
            baseVC.transitionType = style
        }
        
        switch style {
        case .push:
            guard let nav = self.navigationController else { return }
            target.hidesBottomBarWhenPushed = true
            nav.pushViewController(target, animated: animated, completion: completion)
            
        case .dimmPresent(let from, let dimmColor):
            dimmTransitionDelegate.direction = from
            dimmTransitionDelegate.dimmColor = dimmColor
            target.modalPresentationStyle = .custom
            target.transitioningDelegate = dimmTransitionDelegate
            
            self.present(target, animated: animated, completion: completion)
            
        case .present:
            self.present(target, animated: animated, completion: completion)
            
        case .presentNavigation:
            let navTarget = UINavigationController(rootViewController: target)
            navTarget.modalPresentationStyle = .overCurrentContext
            navTarget.setNavigationBarHidden(true, animated: false)
            if let tabBarController = self.tabBarController {
                tabBarController.present(navTarget, animated: animated, completion: completion)
            } else {
                self.present(navTarget, animated: animated, completion: completion)
            }
        }
    }

    ///Close ViewController And Move To ViewController
    func transitionAfterClose(to vc: UIViewController, using style: TransitionType, animated: Bool, completion: (() -> Void)? = nil) {
        
        if let rootNav = self.navigationController {
            self.close(animated: true) {
                let prevVC = rootNav.topViewController as? Self
                prevVC?.transition(to: vc, using: style, animated: animated, completion: completion)
            }
        } else {
            if let presentingVC = self.presentingViewController {
                if let pvc = presentingVC as? Self {
                    self.close(animated: true) {
                        pvc.transition(to: vc, using: style, animated: animated, completion: completion)
                    }
                } else {
                    var prevNavigation: UINavigationController?
                    if let prevNav = presentingVC as? UINavigationController {
                        prevNavigation = prevNav
                    } else if let prevTabBar = presentingVC as? UITabBarController {
                        prevNavigation = prevTabBar.viewControllers?[prevTabBar.selectedIndex] as? UINavigationController
                    }
                    
                    if let prevNav = prevNavigation?.topViewController,
                       let prevVC = prevNav as? Self {
                        self.close(animated: true) {
                            prevVC.transition(to: vc, using: style, animated: animated, completion: completion)
                        }
                    }
                    
                }
            }
        }
    }
    
    ///Close ViewController And Move To Scene
    func transitionAfterClose(to scene: Scene, using style: TransitionType, animated: Bool, completion: (() -> Void)? = nil) {
        let vc = scene.instantiate()
        
        if let rootNav = self.navigationController {
            self.close(animated: true) {
                let prevVC = rootNav.topViewController as? Self
                prevVC?.transition(to: vc, using: style, animated: animated, completion: completion)
            }
        } else {
            if let presentingVC = self.presentingViewController {
                if let pvc = presentingVC as? Self {
                    self.close(animated: true) {
                        pvc.transition(to: vc, using: style, animated: animated, completion: completion)
                    }
                } else {
                    var prevNavigation: UINavigationController?
                    if let prevNav = presentingVC as? UINavigationController {
                        prevNavigation = prevNav
                    } else if let prevTabBar = presentingVC as? UITabBarController {
                        prevNavigation = prevTabBar.viewControllers?[prevTabBar.selectedIndex] as? UINavigationController
                    }
                    
                    if let prevNav = prevNavigation?.topViewController,
                       let prevVC = prevNav as? Self {
                        self.close(animated: true) {
                            prevVC.transition(to: vc, using: style, animated: animated, completion: completion)
                        }
                    }
                }
            }
        }
    }
    
    ///Close ViewController By TransitionType Type
    func close(animated: Bool, completion: (() -> Void)? = nil) {
        switch self.transitionType {
        case .push:
            self.navigationController?.popViewController(animated: animated, completion: completion)
        case .present, .dimmPresent, .presentNavigation:
            self.dismiss(animated: animated, completion: completion)
        default:
            if let nav = self.navigationController {
                nav.popViewController(animated: animated)
            } else if let _ = self.presentingViewController {
                self.dismiss(animated: animated, completion: completion)
            }
        }
    }
    
    ///Close Presenting NavigationController
    func closePresentedNavigation(animated: Bool, completion: (() -> Void)? = nil) {
        self.navigationController?.dismiss(animated: animated, completion: completion)
    }
    
    ///Move To RootViweController
    func moveToRoot(animated: Bool, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            if let rootNav = UIApplication.shared.windows.first?.rootViewController?.navigationController {
                rootNav.dismiss(animated: animated) {
                    rootNav.popToRootViewController(animated: animated)
                    completion?()
                }
            }
        }
    }
}
