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

class CalendarVC: BaseViewController<CalendarReactor> {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateCollectionViewLayout()).then {
        $0.backgroundColor = .clear
        $0.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    
    override func configureLayout() {
        
    }
    
    override func configureLayer() {
        
    }
}

extension CalendarVC {
    
    func bindAction(_ reactor: CalendarReactor) {
    
    }
    
    func bindState(_ reactor: CalendarReactor) {
       
    }
}

extension CalendarVC {
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
