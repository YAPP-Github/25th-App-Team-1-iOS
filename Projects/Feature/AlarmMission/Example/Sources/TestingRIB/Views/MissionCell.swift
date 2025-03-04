//
//  MissionCell.swift
//  AlarmMission
//
//  Created by choijunios on 3/4/25.
//

import UIKit

import SnapKit

final class MissionCell: UITableViewCell {
    
    let label: UILabel = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }
    }
    required init?(coder: NSCoder) { nil }
}
