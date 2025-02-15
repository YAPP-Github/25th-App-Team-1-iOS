//
//  ConfigureBirthDateViewController.swift
//  Setting
//
//  Created by choijunios on 2/14/25.
//

import UIKit

import FeatureCommonDependencies
import FeatureUIDependencies

protocol ConfigureBirthDateViewControllerListener: AnyObject {
    func changedBirthDateConfirmed(date: BirthDateData)
    func dismiss()
}

final class ConfigureBirthDateViewController: UIViewController, BirthDatePickerListener {
    // Sub views
    private let navigationBar: DSAppBar = .init()
    private let backButton: DSDefaultIconButton = .init(
        style: .init(
            type: .default,
            image: FeatureResourcesAsset.gnbLeft.image,
            size: .medium
        )
    )
    private let confirmButton: DSLabelButton = .init(config: .init(
        font: .body1Medium,
        textColor: R.Color.gray500
    ))
    private let titleLabel: UILabel = .init()
    private let birthDatePicker: BirthDatePicker = .init()
    
    
    // Listener
    weak var listener: ConfigureBirthDateViewControllerListener?
    
    
    // State
    private let initialDate: BirthDateData
    private var currentDate: BirthDateData {
        didSet { checkSaveAbility() }
    }
    private var isChanged: Bool {
        initialDate != currentDate
    }
    
    
    init(initialDate: BirthDateData) {
        self.initialDate = initialDate
        self.currentDate = initialDate
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        view.layoutIfNeeded()
        setBirthDate(initialDate)
    }
    
    private func checkSaveAbility() {
        if isChanged {
            confirmButton.isUserInteractionEnabled = true
            confirmButton.update(config: .init(
                font: .body1Medium,
                textColor: R.Color.main100))
        } else {
            confirmButton.isUserInteractionEnabled = false
            confirmButton.update(config: .init(
                font: .body1Medium,
                textColor: R.Color.gray500))
        }
    }
}


// MARK: Setup
private extension ConfigureBirthDateViewController {
    func setupUI() {
        // self
        view.backgroundColor = R.Color.gray900
        
        
        // backButton
        backButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.dismiss()
        }
        
        
        // confirmButton
        confirmButton.isUserInteractionEnabled = false
        confirmButton.update(titleText: "확인")
        confirmButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.changedBirthDateConfirmed(date: currentDate)
            listener?.dismiss()
        }
        
        
        // navigationBar
        navigationBar
            .update(titleText: "프로필 수정")
            .insertLeftView(backButton)
            .insertRightView(confirmButton)
        view.addSubview(navigationBar)
        
        
        // titleLabel
        titleLabel.displayText = "생년월일을 알려주세요".displayText(
            font: .title3SemiBold,
            color: R.Color.white100
        )
        view.addSubview(titleLabel)
        
        
        // birthDatePicker
        birthDatePicker.listener = self
        view.addSubview(birthDatePicker)
    }
    
    func setupLayout() {
        // navigationBar
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        
        // birthDatePicker
        birthDatePicker.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(140)
        }
    }
    
    func setBirthDate(_ birthdateData: BirthDateData) {
        birthDatePicker.update(
            calendarType: birthdateData.calendarType,
            year: birthdateData.year,
            month: birthdateData.month,
            day: birthdateData.day
        )
    }
}


// MARK: BirthDatePickerListener
extension ConfigureBirthDateViewController {
    func latestDate(calendar: CalendarType, year: Year, month: Month, day: Day) {
        let newBirthDate = BirthDateData(calendarType: calendar, year: year, month: month, day: day)
        self.currentDate = newBirthDate
    }
}
