//
//  CreateAlarmView.swift
//  FeatureAlarm
//
//  Created by ever on 12/30/24.
//

import UIKit
import SnapKit
import Then
import FeatureDesignSystem
import FeatureResources

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
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let selectWeekDayView = SelectWeekDayView()
    private let doneButton = DSDefaultCTAButton()
    
    weak var listener: CreateAlarmViewListener?
    
    @objc
    private func doneButtonTapped() {
        listener?.action(.doneButtonTapped)
    }
}

private extension CreateAlarmView {
    func setupUI() {
        backgroundColor = R.Color.gray900
        addSubview(selectWeekDayView)
        doneButton.do {
            $0.update(title: "저장하기")
        }
        addSubview(doneButton)
    }
    
    func layout() {
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        selectWeekDayView.snp.makeConstraints {
            $0.bottom.equalTo(doneButton.snp.top).offset(-24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

