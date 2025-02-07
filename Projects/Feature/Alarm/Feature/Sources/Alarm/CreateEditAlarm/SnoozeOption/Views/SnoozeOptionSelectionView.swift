//
//  SnoozeFrequencyView.swift
//  FeatureAlarm
//
//  Created by ever on 1/22/25.
//

import UIKit
import SnapKit
import Then
import FeatureResources

final class SnoozeOptionSelectionView: UIView {
    private let title: String
    private let options: [SnoozeOptionSelectable]
    
    var optionSelected: ((SnoozeOptionSelectable) -> Void)?
    
    init(
        title: String,
        options: [SnoozeOptionSelectable]
    ) {
        self.title = title
        self.options = options
        super.init(frame: .zero)
        setupUI()
        layout()
        setupOptions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    func disableOptions() {
        [option1Button, option2Button, option3Button, option4Button, option5Button].forEach {
            $0.isEnabled = false
        }
        lineView.backgroundColor = R.Color.gray700
    }
    
    func selectOption(_ option: SnoozeOptionSelectable) {
        guard let index = options.firstIndex(where: { $0.isEqualTo(option) }) else { return }
        deselectAllButtons()
        [option1Button, option2Button, option3Button, option4Button, option5Button].forEach {
            $0.isEnabled = true
            $0.isSelected = false
        }
        lineView.backgroundColor = R.Color.gray600
        switch index {
        case 0:
            option1Button.isSelected = true
        case 1:
            option2Button.isSelected = true
        case 2:
            option3Button.isSelected = true
        case 3:
            option4Button.isSelected = true
        case 4:
            option5Button.isSelected = true
        default:
            break
        }
    }
    
    private let titleLabel = UILabel()
    private let option1Button = AlarmOptionButton()
    private let option1Label = UILabel()
    private let option2Button = AlarmOptionButton()
    private let option2Label = UILabel()
    private let option3Button = AlarmOptionButton()
    private let option3Label = UILabel()
    private let option4Button = AlarmOptionButton()
    private let option4Label = UILabel()
    private let option5Button = AlarmOptionButton()
    private let option5Label = UILabel()
    
    private let lineContainer = UIView()
    private let lineView = UIView()
    private let buttonStackView = UIStackView()
    private let titleStackView = UIStackView()
    
    private func setupOptions() {
        guard options.count == 5 else { return }
        option1Label.displayText = options[0].title.displayText(font: .body1Medium, color: R.Color.white100)
        option2Label.displayText = options[1].title.displayText(font: .body1Medium, color: R.Color.white100)
        option3Label.displayText = options[2].title.displayText(font: .body1Medium, color: R.Color.white100)
        option4Label.displayText = options[3].title.displayText(font: .body1Medium, color: R.Color.white100)
        option5Label.displayText = options[4].title.displayText(font: .body1Medium, color: R.Color.white100)
    }
    
    private func deselectAllButtons() {
        [option1Button, option2Button, option3Button, option4Button, option5Button].forEach {
            $0.isSelected = false
        }
    }
    
    @objc
    private func buttonSelected(button: AlarmOptionButton) {
        switch button {
        case option1Button:
            optionSelected?(options[0])
        case option2Button:
            optionSelected?(options[1])
        case option3Button:
            optionSelected?(options[2])
        case option4Button:
            optionSelected?(options[3])
        case option5Button:
            optionSelected?(options[4])
        default:
            break
        }
    }
}

private extension SnoozeOptionSelectionView {
    func setupUI() {
        titleLabel.do {
            $0.displayText = title.displayText(font: .headline2Medium, color: R.Color.white100)
        }
        lineView.do {
            $0.backgroundColor = R.Color.gray600
        }
        buttonStackView.do {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .equalSpacing
        }
        titleStackView.do {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .equalSpacing
        }
        [lineView, buttonStackView].forEach { lineContainer.addSubview($0) }
        [option1Button, option2Button, option3Button, option4Button, option5Button].forEach {
            buttonStackView.addArrangedSubview($0)
            $0.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        }
        [option1Label, option2Label, option3Label, option4Label, option5Label].forEach {
            titleStackView.addArrangedSubview($0)
        }
        [titleLabel, lineContainer, titleStackView].forEach {
            addSubview($0)
        }
    }
    
    func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(24)
        }
        lineContainer.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(29.5)
            $0.height.equalTo(20)
        }
        lineView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18.5)
            $0.height.equalTo(8)
            $0.centerY.equalToSuperview()
        }
        buttonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(5.5)
            $0.verticalEdges.equalToSuperview()
        }
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(lineContainer.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.bottom.equalToSuperview()
        }
    }
}
