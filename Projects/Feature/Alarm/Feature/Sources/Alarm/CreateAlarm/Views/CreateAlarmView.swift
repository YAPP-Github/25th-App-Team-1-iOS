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
        case meridiemChanged(Meridiem)
        case hourChanged(Int)
        case minuteChanged(Int)
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
    
    private let stackView = UIStackView()
    
    private let meridiemSegmentedControl = UISegmentedControl(items: ["AM", "PM"])
    private let hoursField = UITextField()
    private let minutesField = UITextField()
    private let doneButton = UIButton(type: .system)
    
    weak var listener: CreateAlarmViewListener?
    
    @objc
    private func meridiemChanged(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            listener?.action(.meridiemChanged(.am))
        case 1:
            listener?.action(.meridiemChanged(.pm))
        default:
            break
        }
    }
    
    @objc
    private func hourChanged(_ textField: UITextField) {
        let hour = Int(textField.text ?? "") ?? 1
        listener?.action(.hourChanged(hour))
    }
    
    @objc
    private func minuteChanged(_ textField: UITextField) {
        let minute = Int(textField.text ?? "") ?? 1
        listener?.action(.minuteChanged(minute))
    }
    
    @objc
    private func doneButtonTapped() {
        listener?.action(.doneButtonTapped)
    }
}

private extension CreateAlarmView {
    func setupUI() {
        backgroundColor = .white
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 16
            $0.alignment = .fill
            $0.distribution = .fill
        }
        meridiemSegmentedControl.do {
            $0.selectedSegmentIndex = 0
            $0.addTarget(self, action: #selector(meridiemChanged), for: .valueChanged)
        }
        hoursField.do {
            $0.borderStyle = .roundedRect
            $0.placeholder = "시간 입력: 1~12"
            $0.keyboardType = .asciiCapableNumberPad
            $0.addTarget(self, action: #selector(hourChanged), for: .editingChanged)
        }
        minutesField.do {
            $0.borderStyle = .roundedRect
            $0.placeholder = "분 입력: 0~59"
            $0.keyboardType = .asciiCapableNumberPad
            $0.addTarget(self, action: #selector(minuteChanged), for: .editingChanged)
        }
        
        doneButton.do {
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            $0.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        }
        addSubview(stackView)
        [meridiemSegmentedControl, hoursField, minutesField, doneButton].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    func layout() {
        stackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

