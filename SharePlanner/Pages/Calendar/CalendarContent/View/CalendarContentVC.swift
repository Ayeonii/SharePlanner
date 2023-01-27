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
    
    lazy var calendarView = CalendarView(frame: .zero, yearMonth: state.yearMonth).then {
        $0.backgroundColor = .clear
        $0.collectionView.delegate = self
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reactor.action.onNext(.deselectCell)
    }
   
    override func configureLayout() {
        self.view.addSubview(backgroundImage)
        self.view.addSubview(weekdayView)
        self.view.addSubview(calendarView)
        
        backgroundImage.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        weekdayView.snp.makeConstraints {
            $0.leading.equalTo(view).offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.height.equalTo(25)
            $0.bottom.equalTo(calendarView.snp.top).offset(-10)
        }
        
        calendarView.snp.makeConstraints {
            $0.leading.equalTo(view).offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
}

extension CalendarContentVC {
    
    func bindAction(_ reactor: CalendarContentReactor) {
        
    }
    
    func bindState(_ reactor: CalendarContentReactor) {
        reactor.pulse(\.$yearMonth)
            .asDriver { _ in .never() }
            .drive(onNext: { [weak self] ym in
                if self?.state.oldMonth?.month == ym.month {
                    self?.calendarView.changeJustDay(ym)
                } else {
                    self?.calendarView.changeDate(ym)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.shouldUpdateDefaultSelect }
            .asDriver { _ in .never() }
            .drive(onNext: { [weak self] shouldSelect in
                if shouldSelect {
                    self?.calendarView.updateDefaultSelected()
                } else {
                    self?.calendarView.updateDeselected()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension CalendarContentVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        let height = collectionView.frame.height / CGFloat(calendarView.numberOfWeeks)
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCVCell else { return }
        
        guard !cell.isToday else { return }
        calendarView.selectedIndexPath = indexPath
        cell.setSelected(isSelect: true)
        
        let selectedDate = YearMonth(year: state.yearMonth.year, month: state.yearMonth.month, day: cell.cellNum ?? 1)
        reactor.action.onNext(.setYearMonth(selectedDate))
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarCVCell else { return }
        
        cell.setSelected(isSelect: false)
    }
}
