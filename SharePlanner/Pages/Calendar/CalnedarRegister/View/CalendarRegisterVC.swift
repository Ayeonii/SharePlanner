//
//  CalendarRegisterVC.swift
//  SharePlanner
//
//  Created by Ayeon on 2023/01/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class CalendarRegisterVC: BaseViewController<CalendarRegisterReactor> {
    lazy var dateLabel = UILabel().then {
        $0.text = "\(state.ymd.getDateToString())"
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureLayout() {
        self.view.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bindAction(_ reactor: CalendarRegisterReactor) {
        
    }
    
    func bindState(_ reactor: CalendarRegisterReactor) {
        
    }
}

extension CalendarRegisterVC {
    
}
