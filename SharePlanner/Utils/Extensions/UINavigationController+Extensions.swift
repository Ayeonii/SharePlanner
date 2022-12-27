//
//  UINavigationController+Extensions.swift
//  SharePlanner
//
//  Created by Ayeon on 2022/12/22.
//

import UIKit

extension UINavigationController {
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true, completion : (()->Void)? = nil) {
        if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
            popToViewController(vc, animated: animated)
            doAfterAnimatingTransition(animated: animated, completion: completion)
        }
    }
    
    func popViewControllers(viewsToPop: Int, animated: Bool = true) {
        if viewControllers.count > viewsToPop {
            let vc = viewControllers[viewControllers.count - viewsToPop - 1]
            popToViewController(vc, animated: animated)
        }
    }
    
    private func doAfterAnimatingTransition(animated: Bool, completion: (() -> Void)? = nil) {
        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil, completion: { _ in
                completion?()
            })
        } else {
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        pushViewController(viewController, animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
    
    func popViewController(animated: Bool, completion: (() -> Void)? = nil) {
        popViewController(animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
    
    func popToRootViewController(animated: Bool, completion: (() -> Void)? = nil) {
        popToRootViewController(animated: animated)
        doAfterAnimatingTransition(animated: animated, completion: completion)
    }
    
}

