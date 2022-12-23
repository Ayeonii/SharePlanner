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

class CalendarContentVC: BaseViewController<CalendarContentReactor> {

    let backgroundImage = UIImageView().then {
        $0.image = UIImage(named: "sketchImage")
        $0.backgroundColor = .clear
    }
    
    let weekdayView = WeekdayView().then {
        $0.backgroundColor = .clear
    }
    
    let calendarView = CalendarView().then {
        $0.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    
    override func configureLayout() {
        self.view.addSubview(backgroundImage)
        self.view.addSubview(weekdayView)
        self.view.addSubview(calendarView)
        
        backgroundImage.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        weekdayView.snp.makeConstraints {
            $0.leading.equalTo(view).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.height.equalTo(25)
            $0.bottom.equalTo(calendarView.snp.top)
        }
        
        calendarView.snp.makeConstraints {
            $0.leading.equalTo(view).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
    
    override func configureLayer() {
        
    }
}

extension CalendarContentVC {
    
    func bindAction(_ reactor: CalendarContentReactor) {
    
    }
    
    func bindState(_ reactor: CalendarContentReactor) {
       
    }
}

extension CalendarContentVC {
    func generateCollectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(section: generateCalendarViewSectionLayout())
    }
    
    func generateCalendarViewSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width), heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 2
        
        return section
    }
}