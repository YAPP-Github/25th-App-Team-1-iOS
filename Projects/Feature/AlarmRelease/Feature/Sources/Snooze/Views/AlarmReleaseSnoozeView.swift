//
//  AlarmReleaseSnoozeView.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/12/25.
//

import UIKit
import FeatureCommonDependencies
import FeatureUIDependencies
import FeatureThirdPartyDependencies

protocol AlarmReleaseSnoozeViewListener: AnyObject {
    func action(_ action: AlarmReleaseSnoozeView.Action)
}

final class AlarmReleaseSnoozeView: UIView {
    enum Action {
        case timerFinished
        case releaseAlarmButtonTapped
    }
    
    enum State {
        case startTimer(SnoozeOption)
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var listener: AlarmReleaseSnoozeViewListener?
    
    func update(_ state: State) {
        switch state {
        case .startTimer(let snoozeOption):
            guageView.totalTime = TimeInterval(snoozeOption.frequency.rawValue * 60)
            guageView.startTimer()
        }
    }
    
    private let titleLabel = UILabel()
    private let guageView = CircularGaugeView()
    private let releaseAlarmButton = UIButton(type: .system)
    
    @objc
    private func releaseAlarmButtonTapped() {
        guageView.stopTimer()
        listener?.action(.releaseAlarmButtonTapped)
    }
}

extension AlarmReleaseSnoozeView: CircularGaugeViewListener {
    func action(_ action: CircularGaugeView.Action) {
        switch action {
        case .timerFinished:
            listener?.action(.timerFinished)
        }
    }
}

private extension AlarmReleaseSnoozeView {
    func setupUI() {
        backgroundColor = R.Color.snoozeBackground
        titleLabel.do {
            $0.displayText = "알람 미루기".displayText(font: .heading2SemiBold, color: R.Color.white100)
        }
        guageView.listener = self
        releaseAlarmButton.do {
            $0.setAttributedTitle("알람끄기".displayText(font: .headline1SemiBold, color: R.Color.white100), for: .normal)
            $0.backgroundColor = R.Color.white20
            $0.layer.cornerRadius = 29
            $0.layer.cornerCurve = .continuous
            $0.addTarget(self, action: #selector(releaseAlarmButtonTapped), for: .touchUpInside)
        }
        [titleLabel, guageView, releaseAlarmButton].forEach {
            addSubview($0)
        }
    }
    
    func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(83)
            $0.centerX.equalToSuperview()
        }
        
        guageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(274)
        }
        
        releaseAlarmButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-48)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(169)
            $0.height.equalTo(58)
        }
        
        guageView.setNeedsDisplay()
    }
}


