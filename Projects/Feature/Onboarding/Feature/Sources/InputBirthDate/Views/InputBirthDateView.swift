//
//  InputBirthDateView.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import UIKit

import FeatureResources
import FeatureDesignSystem

protocol InputBirthDateViewListener: AnyObject {
    
    func action(_ action: InputBirthDateView.Action)
}


final class InputBirthDateView: UIView, OnBoardingNavBarViewListener, DSDefaultCTAButtonListener, BirthDatePickerListener {
    
    // View action
    enum Action {
        
        
    }
    
    
    // Sub view
    private let navigationBar: OnBoardingNavBarView = .init()
    private let titleLabel: UILabel = .init()
    private let birthDatePicker: BirthDatePicker = .init()
    private let ctaButton: DSDefaultCTAButton = .init(initialState: .active)
    
    
    // Listener
    weak var listener: InputBirthDateViewListener?
    
    
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
        birthDatePicker.updateToNow()
        addSubview(birthDatePicker)
        
        
        // ctaButton
        ctaButton.listener = self
        ctaButton.update("만들기")
        addSubview(ctaButton)
    }
    
    
    private func setupLayout() {
        
        // navigationBar
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide.snp.horizontalEdges)
        }
        
        
        // label stack
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(navigationBar.snp.bottom).inset(-38)
        }
        
        
        // birthDataPicker
        birthDatePicker.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-69)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide.snp.horizontalEdges)
                .inset(20)
        }
        
        
        // ctaButton
        ctaButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide.snp.horizontalEdges)
                .inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
                .inset(20.42)
        }
    }
}


// MARK: OnBoardingNavBarViewListener
extension InputBirthDateView {
    
    func action(_ action: OnBoardingNavBarView.Action) {
        
        print("back button")
    }
}


// MARK: DSDefaultCTAButtonListener
extension InputBirthDateView {
    
    func action(_ action: DSDefaultCTAButton.Action) {
        
        print("CTAButton")
    }
}


// MARK: BirthDatePickerListener
extension InputBirthDateView {
    
    func latestDate(calendar: CalendarType, year: Int, month: Int, day: Int) {
        
        print("\(calendar) \(year) \(month) \(day)")
    }
}


#Preview {
    
    InputWakeUpAlarmView()
}
