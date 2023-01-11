//
//  SettingVC.swift
//  SharePlanner
//
//  Created by 이아연 on 2023/01/11.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit
import Then

class SettingVC: BaseViewController<SettingReactor> {

    let topView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let topLineView = UIView().then {
        $0.backgroundColor = .appColor(.lightGray)
    }
    
    let closeBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "closeX"), for: .normal)
    }
    
    let topTitle = UILabel().then {
        $0.text = "설정"
        $0.textAlignment = .center
        $0.font = .appFont(size: 30)
        $0.textColor = .appColor(.textPrimary)
    }
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(SettingTVCell.self, forCellReuseIdentifier: SettingTVCell.identifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    func bindAction(_ reactor: SettingReactor) {
        closeBtn.rx.tap
            .map{ SettingReactor.Action.closeView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(_ reactor: SettingReactor) {
        reactor.pulse(\.$settingMenuList)
            .bind(to: self.tableView.rx.items(cellIdentifier: SettingTVCell.identifier, cellType: SettingTVCell.self)) { index, item, cell in
                cell.cellModel = item
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.shouldCloseView }
            .asDriver{ _ in .never() }
            .drive(onNext: { [weak self] _ in
                self?.close(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func configureLayout() {
        view.addSubview(topView)
        view.addSubview(tableView)
        
        topView.addSubview(topTitle)
        topView.addSubview(closeBtn)
        topView.addSubview(topLineView)
        
        topView.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(52)
        }
        
        topTitle.snp.makeConstraints {
            $0.centerX.centerY.height.equalToSuperview()
        }
        
        closeBtn.snp.makeConstraints {
            $0.width.height.equalTo(15)
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        topLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.right.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

extension SettingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
