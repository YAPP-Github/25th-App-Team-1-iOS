//
//  InputBirthDateView.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import UIKit

import FeatureUIDependencies
import FeatureCommonDependencies

protocol InputBirthDateViewListener: AnyObject {
    func action(_ action: InputBirthDateView.Action)
}


final class InputBirthDateView: UIView, OnBoardingNavBarViewListener, BirthDatePickerListener {
    
    // View action
    enum Action {
        case backButtonClicked
        case birthDatePicker(BirthDateData)
        case ctaButtonClicked
    }
    
    
    // Sub view
    private let navigationBar: OnBoardingNavBarView = .init()
    private let titleLabel: UILabel = .init()
    let birthDatePicker: BirthDatePicker = .init()
    private let ctaButton: DSDefaultCTAButton = .init(initialState: .active)
    private let policyAgreementLabel = PolicyAgreementLabel()
    
    // Listener
    weak var listener: InputBirthDateViewListener?
    
    func setBirthDate(_ birthdateData: BirthDateData) {
        birthDatePicker.update(
            calendarType: birthdateData.calendarType,
            year: birthdateData.year,
            month: birthdateData.month,
            day: birthdateData.day
        )
    }
    
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
        navigationBar.setIndex(2, of: 6)
        addSubview(navigationBar)
        
        
        // titleLabel
        titleLabel.numberOfLines = 2
        titleLabel.displayText = "운세를 볼 수 있도록\n생년월일을 알려주세요"
            .displayText(
                font: .heading1SemiBold,
                color: R.Color.white100
            )
        // 라벨 텍스트 Alignment조정
        if let existingParagraphStyle = titleLabel.attributedText?.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSMutableParagraphStyle {
            existingParagraphStyle.alignment = .center
            var attributes = titleLabel.attributedText?.attributes(at: 0, effectiveRange: nil)
            attributes?[.paragraphStyle] = existingParagraphStyle
            titleLabel.attributedText = NSAttributedString(
                string: titleLabel.attributedText?.string ?? "",
                attributes: attributes
            )
        }
        addSubview(titleLabel)
        
        
        // alarmPicker
        birthDatePicker.listener = self
        birthDatePicker.updateToOneYearAgo()
        addSubview(birthDatePicker)
        
        
        // ctaButton
        ctaButton.buttonAction = { [weak self] in
            self?.listener?.action(.ctaButtonClicked)
        }
        ctaButton.update(title: "다음")
        addSubview(ctaButton)
        addSubview(policyAgreementLabel)
    }
    
    
    private func setupLayout() {
        
        // navigationBar
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        
        // label stack
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(navigationBar.snp.bottom).inset(-38)
        }
        
        
        // birthDataPicker
        birthDatePicker.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(69)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
                .inset(20)
        }
        
        // policyAgreementLabel
        policyAgreementLabel.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            make.horizontalEdges.equalToSuperview()
        }
        
        // ctaButton
        ctaButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(policyAgreementLabel.snp.top).offset(-12)
        }
    }
}


// MARK: OnBoardingNavBarViewListener
extension InputBirthDateView {
    
    func action(_ action: OnBoardingNavBarView.Action) {
        
        listener?.action(.backButtonClicked)
    }
}

// MARK: BirthDatePickerListener
extension InputBirthDateView {
    
    func latestDate(calendar: CalendarType, year: Year, month: Month, day: Day) {
        
        let data: BirthDateData = .init(calendarType: calendar, year: year, month: month, day: day)
        
        listener?.action(.birthDatePicker(data))
    }
}


#Preview {
    
    InputWakeUpAlarmView()
}
