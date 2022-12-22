//
//  CalendarViewController.swift
//  SharePlanner
//
//  Created by Ayeon on 2022/12/22.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit
import Then

class CalendarViewController: BaseViewController<CalendarReactor> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
    }
    
    override func configureLayout() {
        
    }
    
    override func configureLayer() {
        
    }
}

extension CalendarViewController {
    
    func bindAction(_ reactor: CalendarReactor) {
    
    }
    
    func bindState(_ reactor: CalendarReactor) {
       
    }
}
