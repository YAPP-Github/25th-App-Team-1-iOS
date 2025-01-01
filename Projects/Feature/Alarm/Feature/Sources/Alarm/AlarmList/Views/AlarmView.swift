//
//  AlarmView.swift
//  FeatureAlarmExample
//
//  Created by ever on 12/29/24.
//

import UIKit
import SnapKit
import Then
import FeatureDesignSystem

protocol AlarmListViewListener: AnyObject {
    func action(_ action: AlarmListView.Action)
}

final class AlarmListView: UIView {
    enum Action {
        case addButtonTapped
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var listener: AlarmListViewListener?
    
    private let addButton = UIButton(type: .system)
    @objc
    private func addButtonTapped() {
        listener?.action(.addButtonTapped)
    }
}

private extension AlarmListView {
    func setupUI() {
        backgroundColor = .white
        addButton.do {
            $0.setImage(R.Image.svgBtnAdd?.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 30
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        }
        
        addSubview(addButton)
    }
    
    func layout() {
        addButton.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.trailing.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
        }
    }
}
