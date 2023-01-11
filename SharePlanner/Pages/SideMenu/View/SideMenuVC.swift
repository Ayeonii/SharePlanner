//
//  SideMenuVC.swift
//  SharePlanner
//
//  Created by 이아연 on 2022/12/28.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import ReactorKit
import SnapKit
import Then

class SideMenuVC: BaseViewController<SideMenuReactor> {
    var viewTranslation = CGPoint(x: 0, y: 0)
    lazy var viewDismissPointX : CGFloat = (self.sideView.frame.width / 2) + 20
    
    let backView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let sideView = UIImageView().then {
        $0.image = UIImage(named: "sideBackground")
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
    }
    
    let settingBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "settingIcon"), for: .normal)
    }

    let profileView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "person")
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.appColor(.lightGray).cgColor
    }
    
    let profileName = UILabel().then {
        $0.textAlignment = .center
        $0.font = .appFont(size: 30)
        $0.textColor = .appColor(.textPrimary)
        $0.text = "이아연"
    }
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.register(SideMenuTVCell.self, forCellReuseIdentifier: SideMenuTVCell.identifier)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureLayout() {
        view.addSubview(backView)
        view.addSubview(sideView)
        sideView.addSubview(profileView)
        sideView.addSubview(tableView)
        profileView.addSubview(profileImage)
        profileView.addSubview(profileName)
        profileView.addSubview(settingBtn)
        
        backView.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview()
            $0.left.equalTo(sideView.snp.right)
        }
        
        sideView.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-150)
        }
        
        profileView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }

        profileImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(60)
        }

        profileName.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(5)
            $0.left.right.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-50)
        }
        
        settingBtn.snp.makeConstraints {
            $0.width.height.equalTo(22)
            $0.left.equalToSuperview().offset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(13)
        }
 
        tableView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    override func configureLayer() {
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
    }
    
    func bindAction(_ reactor: SideMenuReactor) {
        settingBtn.rx.tap
            .map{ SideMenuReactor.Action.showSetting }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backView.rx.tapGesture()
            .when(.recognized)
            .map{ _ in SideMenuReactor.Action.closeView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        view.rx
            .panGesture()
            .when(.changed, .ended)
            .map{ [weak self] pan in
                guard let self = self else { return SideMenuReactor.Action.noneAction}
                switch pan.state {
                case .changed :
                    self.viewTranslation = pan.translation(in: self.sideView)
                    if self.viewTranslation.x < 0 {
                        return SideMenuReactor.Action.transformSideViewX(self.viewTranslation.x)
                    }
                case .ended :
                    self.tableView.bounces = true
                    let velocity = pan.velocity(in: self.sideView)
                
                    let isSwipeLeft = velocity.x < 0
                    let isExceedTranslation = abs(self.viewTranslation.x) >= self.viewDismissPointX
                    let isFastVelocity = velocity.x.magnitude > 1000
                    let isDismissAvailable = (isFastVelocity || isExceedTranslation) && isSwipeLeft
                    
                    if isDismissAvailable {
                        return SideMenuReactor.Action.closeView
                    } else {
                        return SideMenuReactor.Action.transformToOriginal
                    }
                default:
                    break
                }
                return SideMenuReactor.Action.noneAction
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: SideMenuReactor) {
        reactor.state
            .filter{ $0.shouldClose }
            .asDriver{ _ in .never() }
            .drive(onNext: { [weak self] _ in
                self?.close(animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$sideMenuList)
            .bind(to: self.tableView.rx.items(cellIdentifier: SideMenuTVCell.identifier, cellType: SideMenuTVCell.self)) { index, item, cell in
                cell.cellModel = item
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$sideViewTranslateX)
            .compactMap{ $0 }
            .asDriver{ _ in .never() }
            .drive(onNext: { [weak self] x in
                if x == 0 {
                    UIView.animate(withDuration: 0.3,
                                   delay: 0,
                                   options: .curveEaseOut,
                                   animations: {
                        self?.sideView.transform = .identity
                    })
                } else {
                    self?.sideView.transform = CGAffineTransform(translationX: x, y: 0)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .filter{ $0.shouldShowSetting }
            .asDriver{ _ in .never() }
            .drive(onNext: { [weak self] _ in
                self?.showSetting()
            })
            .disposed(by: disposeBag)
    }
}

extension SideMenuVC {
    func showSetting() {
        let reactor = SettingReactor()
        let vc = Scene.setting(reactor).instantiate()
        vc.modalPresentationStyle = .overCurrentContext
        self.transition(to: vc, using: .present, animated: true)
    }
}

extension SideMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
