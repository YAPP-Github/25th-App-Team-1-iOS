//
//  CreateAlarmView.swift
//  FeatureAlarm
//
//  Created by ever on 12/30/24.
//

import UIKit
import SnapKit
import Then

protocol CreateAlarmViewListener: AnyObject {
    func action(_ action: CreateAlarmView.Action)
}

final class CreateAlarmView: UIView {
    enum Action {
        case doneButtonTapped
    }
    private let titleLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "Create Alarm"
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let doneButton = UIButton(type: .system)
    weak var listener: CreateAlarmViewListener?
    
    @objc
    private func doneButtonTapped() {
        listener?.action(.doneButtonTapped)
    }
}

private extension CreateAlarmView {
    func setupUI() {
        backgroundColor = .white
        doneButton.do {
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            $0.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        }
    }
    
    func layout() {
        
    }
}

