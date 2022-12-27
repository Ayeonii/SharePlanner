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
    var presentYM: YearMonth
    var numberOfWeeks: Int = 5
    
    lazy var getFirstWeekday: Int = {
        let day = ("\(presentYM.year)-\(presentYM.month.rawValue)-01".date?.firstDayOfTheMonth.weekday)!
        log.debug("day", day)
        return day
    }()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.allowsSelection = false
        $0.delegate = self
        $0.dataSource = self
        $0.register(CalendarCVCell.self, forCellWithReuseIdentifier: CalendarCVCell.identifier)
    }
    
    init(frame: CGRect, yearMonth: YearMonth) {
        self.presentYM = yearMonth
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented -> DO NOT USE on Storyboard")
    }
    
    private func configureLayout() {
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func changeDate(_ yearMonth: YearMonth) {
        self.presentYM = yearMonth
        collectionView.reloadData()
    }
}

extension CalendarView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let minimumCellCount = presentYM.month.getNumberOfDays(year: presentYM.year) + getFirstWeekday - 1
        let dateNumber = minimumCellCount % 7 == 0 ? minimumCellCount : minimumCellCount + (7 - (minimumCellCount % 7))
        numberOfWeeks = dateNumber / 7
        return dateNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCVCell.identifier, for: indexPath) as? CalendarCVCell else { return UICollectionViewCell() }
        
        let startWeekdayOfMonthIndex = getFirstWeekday - 1
        let minimumCellCount = presentYM.month.getNumberOfDays(year: presentYM.year) + getFirstWeekday - 1
                
        let date: Int
        if indexPath.item < startWeekdayOfMonthIndex {
            cell.dateLabel.textColor = .appColor(.gray)
            let prevYM = presentYM.getPrevYM()
            let prevMonth = prevYM.month
            let prevMonthDate = prevMonth.getNumberOfDays(year: prevYM.year)
            date = prevMonthDate - (startWeekdayOfMonthIndex - 1) + indexPath.row
             
        } else if indexPath.item >= minimumCellCount {
            cell.dateLabel.textColor = .appColor(.gray)
            date = indexPath.item - minimumCellCount + 1
            
        } else {
            date = indexPath.row - startWeekdayOfMonthIndex + 1
            
            let weekdayIndex: Int = (date % 7) + startWeekdayOfMonthIndex - 1
            
            if weekdayIndex == 7 {
                cell.dateLabel.textColor = .appColor(.rosePink)
            } else if weekdayIndex == 6 {
                cell.dateLabel.textColor = .appColor(.blue)
            } else {
                cell.dateLabel.textColor = .appColor(.textPrimary)
            }
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
        let height = collectionView.frame.height / CGFloat(numberOfWeeks)
        
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
