//
//  AlarmCell.swift
//  Main
//
//  Created by choijunios on 1/31/25.
//

import UIKit

import FeatureResources
import FeatureDesignSystem
import FeatureThirdPartyDependencies
import FeatureCommonDependencies

import RxSwift
import RxRelay

final class AlarmCell: UITableViewCell, AlarmRowViewListener {
    
    // Id
    static let identifier = String(describing: AlarmCell.self)
    
    
    // Action
    typealias Action = AlarmRowView.Action
    
    
    // Listener
    var action: ((Action) -> Void)?
    
    
    // Gesture
    private let longPressGesture: UILongPressGestureRecognizer = .init()
    private let tapGesture: UITapGestureRecognizer = .init()
    
    
    // Sub view
    private let alarmRowView = AlarmRowView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
}


// MARK: Public interface
extension AlarmCell {
    @discardableResult
    func update(renderObject: AlarmCellRO, animated: Bool = true) -> Self {
        alarmRowView.update(renderObject: renderObject, animated: animated)
        return self
    }
}


// MARK: Set up
private extension AlarmCell {
    func setupUI() {
        // contentView
        contentView.backgroundColor = .clear
        
        
        // alarmRowView
        alarmRowView.listener = self
        contentView.addSubview(alarmRowView)
    }
    
    func setupLayout() {
        // alarmRowView
        alarmRowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


// MARK: AlarmRowViewListener
extension AlarmCell {
    func action(_ action: AlarmRowView.Action) {
        self.action?(action)
    }
}
