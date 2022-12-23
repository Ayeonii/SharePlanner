//
//  WeekdayView.swift
//  SharePlanner
//
//  Created by Ayeon on 2022/12/23.
//

import UIKit
import SnapKit
import Then

class WeekdayView: UIView {
    let weekdayArray: [Weekday] = [.sun, .mon, .tue, .wed, .thu, .fri, .sat]
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.allowsSelection = false
        $0.delegate = self
        $0.dataSource = self
        $0.register(WeekdayCVCell.self, forCellWithReuseIdentifier: WeekdayCVCell.identifier)
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
}

extension WeekdayView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekdayArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekdayCVCell.identifier, for: indexPath) as? WeekdayCVCell else { return UICollectionViewCell() }
        cell.cellModel = weekdayArray[indexPath.item]
        return cell
    }
}

extension WeekdayView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}

//MARK: - WeekdayCollectionViewCell
class WeekdayCVCell: UICollectionViewCell {
    static let identifier: String = "WeekdayCVCell"
    
    let weekdayLabel = UILabel().then {
        $0.font = .appFont(size: 25)
        $0.textAlignment = .center
    }
    
    var cellModel: Weekday? {
        didSet {
            guard let model = cellModel else { return }
            weekdayLabel.text = model.rawValue
            weekdayLabel.textColor = model.getTextColor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(weekdayLabel)
        weekdayLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
