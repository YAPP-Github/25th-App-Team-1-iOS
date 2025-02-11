//
//  AlarmReleaseIntroView.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/10/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies
import FeatureCommonDependencies

protocol AlarmReleaseIntroViewListener: AnyObject {
    func action(_ action: AlarmReleaseIntroView.Action)
}

final class AlarmReleaseIntroView: UIView {
    enum Action {
        case snoozeButtonTapped
        case releaseAlarmButtonTapped
    }
    
    enum State {
        case updateTime
        case snoozeOption(SnoozeOption)
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
        generateCurrentTime()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var listener: AlarmReleaseIntroViewListener?
    
    private let backgroundImageView = UIImageView()
    private let meridiemLabel = UILabel()
    private let timeLabel = UILabel()
    private let dateLabel = UILabel()
    private let timeStackView = UIStackView()
    
    private let snoozeButton = SnoozeButton(type: .system)
    private let releaseAlarmButton = UIButton(type: .system)
  
    func update(_ state: State) {
        switch state {
        case .updateTime:
            generateCurrentTime()
        case let .snoozeOption(option):
            snoozeButton.update(option)
        }
    }
    
    private func generateCurrentTime() {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        var hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let weekDay = calendar.component(.weekday, from: date)
        let meridiem: Meridiem = hour >= 12 ? .pm : .am
        
        let weekDayString = switch weekDay {
        case 1: "일요일"
        case 2: "월요일"
        case 3: "화요일"
        case 4: "수요일"
        case 5: "목요일"
        case 6: "금요일"
        case 7: "토요일"
        default: ""
        }
        
        hour = switch meridiem {
        case .am: hour == 0 ? 12 : hour
        case .pm: hour > 12 ? hour : hour - 12
        }
        
        let timeString = String(format: "%d:%02d", hour, minute)
        let dateString = "\(month)월 \(day)일 \(weekDayString)"
        
        meridiemLabel.displayText = meridiem.toKoreanFormat.displayText(font: .title2Medium, color: R.Color.white100)
        timeLabel.displayText = timeString.displayText(font: .displaySemiBold, color: R.Color.white100)
        dateLabel.displayText = dateString.displayText(font: .heading2SemiBold, color: R.Color.white100)
    }
    
    @objc
    private func snoozeButtonTapped() {
        listener?.action(.snoozeButtonTapped)
    }
    
    @objc
    private func releaseAlarmButtonTapped() {
        listener?.action(.releaseAlarmButtonTapped)
    }
}

private extension AlarmReleaseIntroView {
    func setupUI() {
        backgroundImageView.do {
            $0.image = FeatureResourcesAsset.imgBackgroundAlarmRelease.image
            $0.contentMode = .scaleAspectFit
        }
        
        timeStackView.do {
            $0.axis = .horizontal
            $0.alignment = .lastBaseline
            $0.distribution = .fill
            $0.spacing = 12
        }
        
        [meridiemLabel, timeLabel].forEach {
            timeStackView.addArrangedSubview($0)
        }
        
        snoozeButton.do {
            $0.addTarget(self, action: #selector(snoozeButtonTapped), for: .touchUpInside)
        }
        
        releaseAlarmButton.do {
            $0.setAttributedTitle("알람끄기".displayText(font: .headline1SemiBold, color: R.Color.gray900), for: .normal)
            $0.backgroundColor = R.Color.main100
            $0.layer.cornerRadius = 16
            $0.layer.cornerCurve = .continuous
            $0.addTarget(self, action: #selector(releaseAlarmButtonTapped), for: .touchUpInside)
        }
        
        [backgroundImageView, timeStackView, dateLabel, snoozeButton, releaseAlarmButton].forEach {
            addSubview($0)
        }
    }
    
    func layout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        timeStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(71)
            $0.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(timeStackView.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        releaseAlarmButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-48)
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(62)
        }
        
        snoozeButton.snp.makeConstraints {
            $0.bottom.equalTo(releaseAlarmButton.snp.top).offset(-153)
            $0.centerX.equalToSuperview()
        }
    }
}
