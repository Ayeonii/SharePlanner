//
//  DimmPresentManager.swift
//  SharePlanner
//
//  Created by Ayeon on 2022/12/22.
//

import Foundation
import UIKit

enum PresentationDirection {
    case left
    case top
    case right
    case bottom
}

class DimmPresentManager: NSObject, UIViewControllerTransitioningDelegate {
    var direction: PresentationDirection = .bottom
    var dimmColor: UIColor = UIColor.black.withAlphaComponent(0.6)
    
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        presenting?.view.layer.speed = 1.2
        return CustomPresentationController(presentedViewController: presented,
                                            presenting: presenting,
                                            direction: direction,
                                            dimmColor: dimmColor
        )
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return DimmPresentationAnimator(direction: direction, isPresentation: true)
    }
    
    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return DimmPresentationAnimator(direction: direction, isPresentation: false)
    }
}

final class DimmPresentationAnimator: NSObject {
    let direction: PresentationDirection
    let isPresentation: Bool
    
    init(direction: PresentationDirection, isPresentation: Bool) {
        self.direction = direction
        self.isPresentation = isPresentation
        super.init()
    }
}

extension DimmPresentationAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        
        let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from
        
        guard let controller = transitionContext.viewController(forKey: key)
        else { return }
        
        
        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }
        
        
        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        switch direction {
        case .left:
            dismissedFrame.origin.x = -presentedFrame.width
        case .right:
            dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
        case .top:
            dismissedFrame.origin.y = -presentedFrame.height
        case .bottom:
            dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
        }
        
        
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        
        let animationDuration = transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                controller.view.frame = finalFrame
            }, completion: { finished in
                if !self.isPresentation {
                    controller.view.removeFromSuperview()
                }
                transitionContext.completeTransition(finished)
            })
        
    }
}

class CustomPresentationController : UIPresentationController {
    
    private var direction: PresentationDirection
    private var dimmColor: UIColor
    
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         direction: PresentationDirection,
         dimmColor: UIColor) {
        self.direction = direction
        self.dimmColor = dimmColor
        
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            guard let theView = containerView else {
                return CGRect.zero
            }
            return CGRect(x: 0, y: 0, width: theView.bounds.width, height: (theView.bounds.height))
        }
    }
    
    lazy var dimmingView: UIView = {
        let dimmingView = UIView()
        dimmingView.backgroundColor = dimmColor
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        return dimmingView
    }()

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        let superview = presentingViewController.view!
        
        superview.addSubview(dimmingView)
        NSLayoutConstraint.activate([
            dimmingView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            dimmingView.topAnchor.constraint(equalTo: superview.topAnchor)
        ])

        dimmingView.alpha = 0

        switch direction {
        case .bottom:
            presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                self.containerView?.transform = CGAffineTransform(translationX: 0, y: 10)
                self.dimmingView.alpha = 0.5
            }, completion: { _ in
                //스프링 같은 애니메이션 주기 위함.
                UIView.animate(withDuration: 0.25,
                               delay: 0,
                               options: [.curveEaseOut, .allowUserInteraction],
                               animations: {
                    self.containerView?.transform = .identity
                })
            })
        default:
            presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0.5
            })
        }
    }
    
    override func presentationTransitionDidEnd(_ completed : Bool) {
        super.presentationTransitionDidEnd(completed)
       
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }
   
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        }, completion: { _ in
            self.dimmingView.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}
