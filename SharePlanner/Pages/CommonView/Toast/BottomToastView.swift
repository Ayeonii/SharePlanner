//
//  BottomToastView.swift
//  SharePlanner
//
//  Created by Ayeon on 2023/01/19.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxGesture

class BottomToastView: UIView {
    static let shared = BottomToastView()

    var notitimer: Timer?
    var disposeBag = DisposeBag()
    var isPresenting: Bool = false
    var isOnAnimate = false
    let parentViewHeight: CGFloat = 94
    let defaultTabBarHeight = 49 + UIApplication.bottomSafeAreaHeight
    var viewTranslation = CGPoint(x: 0, y: 0)
    lazy var viewDismissPointY = (parentViewHeight / 2) - 10
    
    ///View
    lazy var mainView = UIView().then {
        $0.backgroundColor = UIColor(rgb: 0x2C2C2E).withAlphaComponent(0.8)
        $0.layer.cornerRadius = 10
    }
    
    lazy var messageLabel = UILabel().then {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = .appFont(size: 15)
    }
    
    let screenRect = UIScreen.main.bounds
    var keyboardHeight: CGFloat = 0
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        NotificationCenter.default.addObserver(self, selector:#selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(handleKeyboardHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        self.frame = CGRect(x: 0,
                            y: screenRect.height - parentViewHeight - defaultTabBarHeight + 25,
                            width: screenRect.width,
                            height: parentViewHeight - 30)
        self.isUserInteractionEnabled = true
        configureLayout()
    }
    
    func configureLayout() {
        self.addSubview(mainView)
        mainView.addSubview(messageLabel)
        
        mainView.snp.makeConstraints {
            $0.top.equalTo(self.snp.bottom).offset(50)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        messageLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview().inset(15)
        }
    }
    
    @objc func handleKeyboardShow(notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            self.frame = CGRect(x: 0,
                                      y: (screenRect.height - parentViewHeight - defaultTabBarHeight - keyboardSize.height + 25),
                                      width: screenRect.width,
                                      height: parentViewHeight + keyboardHeight - 30)
        }
    }
    
    @objc func handleKeyboardHide(notification: NSNotification) {
        keyboardHeight = 0
        if self.isPresenting {
            self.updateBottomConstraint(to: -self.mainView.frame.height)
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: [.curveEaseIn, .allowUserInteraction],
                           animations: {
                self.layoutIfNeeded()
            })
            
        } else {
            self.frame = CGRect(x: 0,
                                  y: screenRect.height - parentViewHeight - defaultTabBarHeight + 25,
                                  width: screenRect.width,
                                  height: parentViewHeight - 30)
        }
    }
    
    func show(message: String, duration: TimeInterval = 2.0) {
        if self.isPresenting || self.isOnAnimate {
            self.dismiss() { [weak self] in
                self?.showToastView(message: message, duration: duration)
            }
        } else {
            self.showToastView(message: message, duration: duration)
        }
    }
    
    private func showToastView(message: String, duration: TimeInterval) {
        self.setNotificationTimer(duration: duration)
        self.bindGesture()
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(self)
        
        DispatchQueue.main.async {
            self.messageLabel.text = message
            self.isPresenting = true
            self.isOnAnimate = true
            
            self.updateBottomConstraint(to: -(self.mainView.frame.height + self.keyboardHeight))
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: [.curveEaseIn, .allowUserInteraction],
                           animations: {
                self.layoutIfNeeded()
            }, completion: {[weak self] finish in
                self?.isOnAnimate = false
            })
        }
    }
    
    func setNotificationTimer(duration: TimeInterval) {
        DispatchQueue.main.async {
            if let timer = self.notitimer {
                if timer.isValid {
                    timer.invalidate()
                }
            }
            
            if let timer = self.notitimer  {
                if !timer.isValid {
                    self.notitimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(self.notitimerTimeout), userInfo: nil, repeats: false)
                }
            } else {
                self.notitimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(self.notitimerTimeout), userInfo: nil, repeats: false)
            }
        }
    }
    
    @objc func notitimerTimeout() {
        self.dismiss()
    }

    private func dismiss(completion : (()->Void)? = nil) {
        guard self.isPresenting, !self.isOnAnimate else { return }
        self.disposeGesture()
        self.isPresenting = false
        
        DispatchQueue.main.async {
            self.isOnAnimate = true
            self.updateBottomConstraint(to: 120)
            
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: [.curveEaseOut, .allowUserInteraction],
                           animations: {
                self.layoutIfNeeded()
            }, completion: { finished in
                self.removeFromSuperview()
                self.isOnAnimate = false
                self.transform = .identity
                completion?()
            })
        }
    }
    
    private func bindGesture() {
        self.rx
            .panGesture()
            .when(.changed, .ended)
            .asDriver{ _ in .never() }
            .drive(onNext: { [weak self] pan in
                guard let self = self else { return }
                
                switch pan.state {
                case .changed :
                    self.viewTranslation = pan.translation(in: self)
                    if self.viewTranslation.y > 0 {
                        self.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                    }
                    
                case .ended :
                    let velocity = pan.velocity(in: self)
                    
                    let isPanDown = velocity.y > 0
                    let isExceedTranslation = self.viewTranslation.y >= self.viewDismissPointY
                    let isFastVelocity = velocity.y.magnitude > 1000
                    
                    if (isFastVelocity || isExceedTranslation) && isPanDown {
                        self.dismiss()
                    } else {
                        UIView.animate(withDuration: 0.15,
                                       delay: 0,
                                       options: [.curveEaseIn],
                                       animations: {
                            self.transform = .identity
                        })
                    }
                default :
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func disposeGesture() {
        self.viewTranslation = CGPoint(x: 0, y: 0)
        self.disposeBag = DisposeBag()
    }
    
    func updateBottomConstraint(to: CGFloat) {
        mainView.snp.updateConstraints {
            $0.top.equalTo(self.snp.bottom).offset(to)
        }
    }
}
