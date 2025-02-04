//
//  InputWakeUpAlarmView.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/4/25.
//

import UIKit
import FeatureUIDependencies
import FeatureCommonDependencies

protocol InputWakeUpAlarmViewListener: AnyObject {
    
    func action(_ action: InputWakeUpAlarmView.Action)
}


final class InputWakeUpAlarmView: UIView, OnBoardingNavBarViewListener, AlarmPickerListener {
    
    // View action
    enum Action {
        
        case backButtonClicked
        case alarmPicker(AlarmData)
        case ctaButtonClicked
    }
    
    
    // Sub view
    private let navigationBar: OnBoardingNavBarView = .init()
    private let titleLabel: UILabel = .init()
    private let subTitleLabel: UILabel = .init()
    private let alarmPicker: AlarmPicker = .init()
    private let ctaButton: DSDefaultCTAButton = .init(initialState: .active)
    
    
    // Listener
    weak var listener: InputWakeUpAlarmViewListener?
    
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    
    private func setupUI() {
        
        // self
        self.backgroundColor = R.Color.gray900
        
        
        // navigationBar
        navigationBar.listener = self
        navigationBar.setIndex(1, of: 6)
        
        // titleLabel
        titleLabel.displayText = "몇시에 깨워 드릴까요?"
            .displayText(
                font: .heading1SemiBold,
                color: R.Color.white100
            )
        
        
        // subTitleLabel
        subTitleLabel.displayText = "설정한 시간에 하루 운세를 함께 드릴게요"
            .displayText(
                font: .body2Regular,
                color: R.Color.gray100
            )
        
        
        // alarmPicker
        alarmPicker.listener = self
        alarmPicker.updateToNow()
        
        
        // ctaButton
        ctaButton.buttonAction = { [weak self] in
            self?.listener?.action(.ctaButtonClicked)
        }
        ctaButton.update(title: "만들기")
    }
    
    
    private func setupLayout() {
        
        // navigationBar
        addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide.snp.horizontalEdges)
        }
        
        
        // label stack
        let labelStackView: UIStackView = .init(arrangedSubviews: [
            titleLabel, subTitleLabel
        ])
        labelStackView.axis = .vertical
        labelStackView.spacing = 4
        labelStackView.alignment = .center
        
        addSubview(labelStackView)
        labelStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(navigationBar.snp.bottom).inset(-40)
        }
        
        
        // alarmPicker
        addSubview(alarmPicker)
        alarmPicker.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).inset(-89)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide.snp.horizontalEdges)
                .inset(20)
        }
        
        
        // ctaButton
        addSubview(ctaButton)
        ctaButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide.snp.horizontalEdges)
                .inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
                .inset(20.42)
        }
    }
}


// MARK: OnBoardingNavBarViewListener
extension InputWakeUpAlarmView {
    
    func action(_ action: OnBoardingNavBarView.Action) {
        
        switch action {
        case .backButtonClicked:
            listener?.action(.backButtonClicked)
        }
    }
}


// MARK: AlarmPickerListener
extension InputWakeUpAlarmView {
    func latestSelection(meridiem: Meridiem, hour: Hour, minute: Minute) {
        let alarmData = AlarmData(meridiem: meridiem.rawValue, hour: hour.value, minute: minute.value)
        listener?.action(.alarmPicker(alarmData))
    }
}

#Preview {
    
    InputWakeUpAlarmView()
}
