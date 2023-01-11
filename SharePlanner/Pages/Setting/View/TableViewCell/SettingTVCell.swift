//
//  SettingTVCell.swift
//  SharePlanner
//
//  Created by 이아연 on 2023/01/11.
//

import UIKit
import SnapKit
import Then

class SettingTVCell: UITableViewCell {
    static let identifier = "SettingTVCell"
    
    let title = UILabel().then {
        $0.font = .appFont(size: 25)
        $0.textColor = .appColor(.textPrimary)
        $0.textAlignment = .left
    }
    
    var cellModel: String? {
        didSet {
            guard let model = cellModel else { return }
            self.title.text = model
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingTVCell {
    private func configureLayout() {
        contentView.addSubview(title)
        title.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
}
