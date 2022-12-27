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
    let today = Date()
    let todayYM = YearMonth(date: Date())
    
    var selectedIndexPath: IndexPath?
    
    var presentYM: YearMonth
    var numberOfWeeks: Int = 5
    
    var getFirstWeekday: Int {
        let day = ("\(presentYM.year)-\(presentYM.month.rawValue)-01".date?.firstDayOfTheMonth.weekday)!
        return day
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.allowsSelection = true
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
    
    func updateDefaultSelected() {
        guard presentYM != todayYM else { return }
        let startWeekdayOfMonthIndex = getFirstWeekday - 1
        let firstIndexPath = IndexPath(item: startWeekdayOfMonthIndex, section: 0)
        guard let cell = collectionView.cellForItem(at: firstIndexPath) as? CalendarCVCell else { return }
        
        cell.isSelected = true
        cell.setSelected(isSelect: true)
        selectedIndexPath = firstIndexPath
        collectionView.selectItem(at: firstIndexPath, animated: false, scrollPosition: .init())
    }
    
    func updateDeselected() {
        guard let selectedIndexPath = self.selectedIndexPath else { return }
        guard let cell = collectionView.cellForItem(at: selectedIndexPath) as? CalendarCVCell else { return }
        
        cell.isSelected = false
        cell.setSelected(isSelect: false)
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
            
            if todayYM == presentYM, date == today.day {
                cell.isToday = true
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCVCell else { return }
        
        guard !cell.isToday else { return }
        selectedIndexPath = indexPath
        cell.setSelected(isSelect: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCVCell else { return }
        
        cell.setSelected(isSelect: false)
    }
}


class CalendarCVCell: UICollectionViewCell {
    static let identifier = "CalendarCVCell"
    
    var todayNumCoverView = UIView().then {
        $0.backgroundColor = .appColor(.rosePink).withAlphaComponent(0.5)
    }
    
    var selectedCoverView = UIView().then {
        $0.backgroundColor = .appColor(.gray).withAlphaComponent(0.5)
    }
    
    var dateLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .appFont(size: 25)
    }
    
    var isToday: Bool = false
    
    var cellNum: Int? {
        didSet {
            guard let number = cellNum else { return }
            dateLabel.text = "\(number)"
            todayNumCoverView.isHidden = !isToday
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
        self.todayNumCoverView.layer.cornerRadius = self.todayNumCoverView.bounds.height / 2
        self.selectedCoverView.layer.cornerRadius = self.selectedCoverView.bounds.height / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.isToday = false
        self.selectedCoverView.isHidden = true
    }
    
    private func setupView() {
        selectedCoverView.isHidden = true
        todayNumCoverView.isHidden = true

        addSubview(selectedCoverView)
        addSubview(todayNumCoverView)
        addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
        
        todayNumCoverView.snp.makeConstraints {
            $0.centerX.equalTo(dateLabel)
            $0.top.equalTo(dateLabel).offset(3)
            $0.width.height.equalTo(25)
        }
        
        selectedCoverView.snp.makeConstraints {
            $0.edges.equalTo(todayNumCoverView)
        }
    }
    
    func setSelected(isSelect: Bool) {
        guard !isToday else { return }
        selectedCoverView.isHidden = !isSelect
    }
}
