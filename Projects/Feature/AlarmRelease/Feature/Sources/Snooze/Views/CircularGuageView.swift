//
//  CircularGuageView.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/12/25.
//

import UIKit
import FeatureUIDependencies

protocol CircularGaugeViewListener: AnyObject {
    func action(_ action: CircularGaugeView.Action)
}

final class CircularGaugeView: UIView {
    enum Action {
        case timerFinished
    }
    // 전체 시간(초)
    var totalTime: TimeInterval = 60 {
        didSet { remainingTime = totalTime }
    }
    
    // 남은 시간(초) - 변경될 때마다 다시 그리기
    private var remainingTime: TimeInterval = 60 {
        didSet { setNeedsDisplay() }
    }
    
    private var timer: Timer?
    
    // 배경 stroke: 20pt, 전경 stroke: 12pt
    private let backgroundLineWidth: CGFloat = 20.0
    private let foregroundLineWidth: CGFloat = 12.0
    
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    weak var listener: CircularGaugeViewListener?
    
    /// 타이머 시작 (1초마다 남은 시간 감소)
    func startTimer() {
        timer?.invalidate()
        remainingTime = totalTime
        
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc
    private func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
        } else {
            timer?.invalidate()
            listener?.action(.timerFinished)
        }
        updateTimeLabel()
    }
    
    private func updateTimeLabel() {
        let minute = Int(remainingTime) / 60
        let second = Int(remainingTime) % 60
        let timeString = String(format: "%02d:%02d", minute, second)
        timeLabel.displayText = timeString.displayText(font: .displayBold, color: R.Color.white100)
    }
    
    override func draw(_ rect: CGRect) {
        // 중앙과 반지름 계산 (배경 stroke 반의 두께만큼 여유 필요)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - backgroundLineWidth / 2
        
        // 시작각: 상단 가운데 (-π/2)
        let startAngle: CGFloat = -CGFloat.pi / 2
        
        // 1. 배경 원 (전체 원, 흰색, alpha 0.2, 20pt)
        let backgroundPath = UIBezierPath(arcCenter: center,
                                          radius: radius,
                                          startAngle: 0,
                                          endAngle: CGFloat.pi * 2,
                                          clockwise: true)
        backgroundPath.lineWidth = backgroundLineWidth
        UIColor.white.withAlphaComponent(0.2).setStroke()
        backgroundPath.stroke()
        
        // 2. 남은 시간 비율에 따른 각도 계산 (반시계방향으로 줄어듦)
        let progress = CGFloat(remainingTime / totalTime)
        let endAngle = startAngle + (CGFloat.pi * 2 * progress)
        
        // 3. 전경 원 (남은 시간, 노란색, 12pt, stroke 끝은 둥글게)
        let foregroundPath = UIBezierPath(arcCenter: center,
                                          radius: radius,
                                          startAngle: startAngle,
                                          endAngle: endAngle,
                                          clockwise: true)
        foregroundPath.lineWidth = foregroundLineWidth
        foregroundPath.lineCapStyle = .round
        UIColor.yellow.setStroke()
        foregroundPath.stroke()
    }
    
    deinit {
        print(#function)
    }
}

private extension CircularGaugeView {
    func setupUI() {
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
        }
        titleLabel.do {
            $0.displayText = "남은 시간".displayText(font: .headline2SemiBold, color: R.Color.white100)
            $0.textAlignment = .center
        }
        [titleLabel, timeLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        addSubview(stackView)
    }
    
    func layout() {
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
