//
//  CalendarView.swift
//  SharePlanner
//
//  Created by Ayeon on 2022/12/23.
//

import Foundation
import UIKit
import SnapKit
import Then

class CalendarView: UIView {
    var presentMonth: Month = Date().monthType
    var presentYear: Int = Date().year
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.allowsSelection = false
        $0.delegate = self
        $0.dataSource = self
        $0.register(CalendarCVCell.self, forCellWithReuseIdentifier: CalendarCVCell.identifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented -> DO NOT USE on Storyboard")
    }
    
    func configureLayout() {
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func getFirstWeekday() -> Int {
        let day = ("\(presentYear)-\(presentMonth.rawValue)-01".date?.firstDayOfTheMonth.weekday)!
        return day
    }
}

extension CalendarView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let minimumCellCount = presentMonth.getNumberOfDays() + getFirstWeekday() - 1
        let dateNumber = minimumCellCount % 7 == 0 ? minimumCellCount : minimumCellCount + (7 - (minimumCellCount % 7))
        return dateNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCVCell.identifier, for: indexPath) as? CalendarCVCell else { return UICollectionViewCell() }
        
        let startWeekdayOfMonthIndex = getFirstWeekday() - 1
        let minimumCellCount = presentMonth.getNumberOfDays() + getFirstWeekday() - 1
                
        let date: Int
        if indexPath.item < startWeekdayOfMonthIndex {
            cell.dateLabel.textColor = .appColor(.lightGray)
            let prevMonth = presentMonth.rawValue < 2 ? .dec : Month(rawValue: presentMonth.rawValue - 1) ?? .jan
            let prevMonthDate = prevMonth.getNumberOfDays()
            date = prevMonthDate - (startWeekdayOfMonthIndex - 1) + indexPath.row
             
        } else if indexPath.item >= minimumCellCount {
            cell.dateLabel.textColor = .appColor(.lightGray)
            date = indexPath.item - minimumCellCount + 1
            
        } else {
            cell.dateLabel.textColor = .appColor(.textPrimary)
            date = indexPath.row - startWeekdayOfMonthIndex + 1
        }
        cell.cellNum = date
       
        return cell
    }
}

extension CalendarView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        let height = collectionView.frame.height / 5
        return CGSize(width: width, height: height)
    }
}


class CalendarCVCell: UICollectionViewCell {
    static let identifier = "CalendarCVCell"
    
    var dateLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .appFont(size: 25)
    }
    
    var cellNum: Int? {
        didSet {
            guard let number = cellNum else { return }
            dateLabel.text = "\(number)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dateLabel.updateConstraints()
    }
    
    private func setupView() {
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
    }
}
