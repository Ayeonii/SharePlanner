//
//  SideMenuVC.swift
//  SharePlanner
//
//  Created by 이아연 on 2022/12/28.
//

import UIKit
import RxSwift
import ReactorKit
import SnapKit
import Then

class SideMenuVC: BaseViewController<SideMenuReactor> {
    let backView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let sideView = UITableView().then {
        $0.backgroundColor = .clear
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureLayout() {
        
    }
    
    override func configureLayer() {
        
    }
    
    func bindAction(_ reactor: SideMenuReactor) {
        
    }
    
    func bindState(_ reactor: SideMenuReactor) {
        
    }
}

