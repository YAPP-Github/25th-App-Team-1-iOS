//
//  BirthDayPicker.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import UIKit

import FeatureUIDependencies
import FeatureThirdPartyDependencies
import FeatureCommonDependencies
import RxSwift

protocol BirthDatePickerListener: AnyObject {
    func latestDate(calendar: CalendarType, year: Year, month: Month, day: Day)
}

final class BirthDatePicker: UIView {
    
    // Sub view
    private let calendarColumn: BirthDatePickerColumnView = {
        let selectionItemViewSize: CGSize = .init(width: 48, height: 38)
        let selectionItems = CalendarType.displayOrderList.map { calendarType in
            BirthDaySelectionItem(
                content: calendarType.content,
                displayingText: calendarType.displayKoreanText,
                contentSize: selectionItemViewSize
            )
        }
        return BirthDatePickerColumnView(itemSpacing: 12, items: selectionItems)
    }()
    private let yearColumn: BirthDatePickerColumnView = {
        let selectionItemViewSize: CGSize = .init(width: 63, height: 38)
        let currentYear = Calendar.current.dateComponents([.year], from: .now).year!
        let selectionItems = (1900...(currentYear-1)).map { yearItem in
            BirthDaySelectionItem(
                content: String(yearItem),
                displayingText: String(yearItem),
                contentSize: selectionItemViewSize
            )
        }
        return BirthDatePickerColumnView(itemSpacing: 12, items: selectionItems)
    }()
    private let monthColumn: BirthDatePickerColumnView = {
        let selectionItemViewSize: CGSize = .init(width: 40, height: 38)
        let selectionItems = (1...12).map { monthItem in
            
            BirthDaySelectionItem(
                content: String(monthItem),
                displayingText: String(monthItem),
                contentSize: selectionItemViewSize
            )
        }
        return BirthDatePickerColumnView(itemSpacing: 12, items: selectionItems)
    }()
    private let dayColumn: BirthDatePickerColumnView = {
        let selectionItemViewSize: CGSize = .init(width: 42, height: 38)
        let selectionItems = (1...30).map { dayItem in
            
            var displayingText = "\(dayItem)"
            if dayItem < 10 {
                displayingText = "0\(dayItem)"
            }
            return BirthDaySelectionItem(
                content: String(dayItem),
                displayingText: displayingText,
                contentSize: selectionItemViewSize
            )
        }
        return BirthDatePickerColumnView(itemSpacing: 12, items: selectionItems)
    }()
    
    private let inBoundDisplayView: UIView = .init()
    private var gradientLayer: CALayer?
    
    
    // Listener
    weak var listener: BirthDatePickerListener?
    
    
    // Rx
    private let disposeBag: DisposeBag = .init()
    
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
        setReactive()
    }
    required init?(coder: NSCoder) { nil }
    
    
    private func setupUI() {
        
        // self
        self.backgroundColor = R.Color.gray900
        
        
        // inBoundDisplayView
        inBoundDisplayView.backgroundColor = R.Color.gray700
        inBoundDisplayView.layer.cornerRadius = 12
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let gradientLayer {
            gradientLayer.frame = self.bounds
        } else {
            createGradientLayer()
        }
    }
    
    
    private func setupLayout() {
        
        // inBoundDisplayView
        addSubview(inBoundDisplayView)
        inBoundDisplayView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
        }
        
        
        // columnStackView
        let columnStackView: UIStackView = .init(arrangedSubviews: [
            calendarColumn,
            UIStackView.Spacer(contentSize: .init(width: 28, height: 0)),
            yearColumn,
            UIStackView.Spacer(contentSize: .init(width: 24, height: 0)),
            monthColumn,
            UIStackView.Spacer(contentSize: .init(width: 24, height: 0)),
            dayColumn
        ])
        columnStackView.axis = .horizontal
        columnStackView.distribution = .fill
        columnStackView.alignment = .center
        
        addSubview(columnStackView)
        columnStackView.snp.makeConstraints { make in
            
            make.verticalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    
    private func setReactive() {
        
        // 일(day)수를 변경시키는 옵저버블
        let calYearMonthChangeObservable = Observable.combineLatest(
            calendarColumn.rx.selectedContent.distinctUntilChanged(),
            yearColumn.rx.selectedContent.distinctUntilChanged(),
            monthColumn.rx.selectedContent.distinctUntilChanged()
        )
        
        
        // 일수가 업데이트됨
        let dateIsUpdated = calYearMonthChangeObservable
            .withUnretained(self)
            .map({ view, bundle in
                
                let (calendar, yearValue, monthValue) = bundle
                
                var calendarType: CalendarType!
                
                switch calendar {
                case CalendarType.lunar.content:
                    calendarType = .lunar
                case CalendarType.gregorian.content:
                    calendarType = .gregorian
                default:
                    fatalError()
                }
                
                guard let yearInt = Int(yearValue), let monthInt = Int(monthValue) else {
                    fatalError()
                }
                
                let year = Year(yearInt)
                guard let month = Month(rawValue: monthInt), let month = Month(rawValue: monthInt) else {
                    fatalError()
                }
                
                let newDayRange = view.updateDay(calendarType: calendarType, year: year, month: month)
                
                return (calendar, year, month, newDayRange)
            })
        
        
        // 일의 변화를 관찰
        let dayChangeObservable = dayColumn.rx.selectedContent.distinctUntilChanged()
        
        Observable
            .combineLatest(dateIsUpdated, dayChangeObservable)
            .subscribe(onNext: { [weak self] bundle, dayValue in
                
                let (calendar, year, month, newDayRange) = bundle
                
                guard let self else { return }
                
                var calendarType: CalendarType!
                
                switch calendar {
                case CalendarType.lunar.content:
                    calendarType = .lunar
                case CalendarType.gregorian.content:
                    calendarType = .gregorian
                default:
                    fatalError()
                }
                
                guard let dayInt = Int(dayValue),
                      let day = Day(dayInt, month: month, year: year)
                else { fatalError() }
                
                listener?.latestDate(calendar: calendarType, year: year, month: month, day: day)
            })
            .disposed(by: disposeBag)
    }
}


// MARK: Public interface
extension BirthDatePicker {
    
    func updateToOneYearAgo() {
        
        let gregorianCalendar = Calendar(identifier: .gregorian)
        
        guard let oneYearAgoDate = gregorianCalendar.date(byAdding: .year, value: -1, to: .now) else { return }
        
        let dateComponents = gregorianCalendar.dateComponents([.year, .month, .day], from: oneYearAgoDate)
        
        guard let yearValue = dateComponents.year, let monthValue = dateComponents.month, let dayValue = dateComponents.day else { return }
        let year = Year(yearValue)
        guard let month = Month(rawValue: monthValue), let day = Day(dayValue, month: month, year: year) else { return }
        
        let calendarType: CalendarType = .gregorian
        
        // update picker
        update(calendarType: calendarType, year: year, month: month, day: day)
    }
    
    
    func update(calendarType: CalendarType, year: Year, month: Month, day: Day) {
        
        // calendarType
        calendarColumn.rx.setContent.accept(calendarType.content)
        
        // year
        yearColumn.rx.setContent.accept(String(year.value))
        
        // month
        monthColumn.rx.setContent.accept(String(month.rawValue))
        
        // day
        updateDay(calendarType: calendarType, year: year, month: month)
        dayColumn.rx.setContent.accept(String(day.value))
    }
    
    
    /// 새롭게 업데이트되는 일수를 반환
    @discardableResult
    func updateDay(calendarType: CalendarType, year: Year, month: Month) -> Range<Int> {
        
        let calendar = Calendar(identifier: calendarType.calendarIdentifier)
        
        let lastDay = Day.lastDay(of: month, in: year)
        
        let range = 1...lastDay
        let updatedItems: [BirthDaySelectionItem] = range.map { day in
            var displayingText = String(format: "%02d", day)
            
            let selectionItemViewSize: CGSize = .init(width: 42, height: 38)
            
            return BirthDaySelectionItem(
                content: String(day),
                displayingText: displayingText,
                contentSize: selectionItemViewSize
            )
        }
        
        dayColumn.update(items: updatedItems)
        
        return Range(range)
    }
}


// MARK: Gradient
private extension BirthDatePicker {
    
    func createGradientLayer() {
        
        guard let backgroundColor else { return }
        
        // CAGradientLayer 생성
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        // 그라디언트 색상 배열 설정
        gradientLayer.colors = [
            backgroundColor.cgColor,
            backgroundColor.withAlphaComponent(0.0).cgColor,
            backgroundColor.withAlphaComponent(0.0).cgColor,
            backgroundColor.cgColor,
        ]
        
        // 그라디언트 방향 설정 (상단에서 하단으로)
        gradientLayer.locations = [0, 0.3, 0.6, 1]
        
        // 레이어 추가
        self.layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
    }
}


// MARK: UIStackView+Spacer
fileprivate extension UIStackView {
        
    class Spacer: UIView {
        
        let contentSize: CGSize?
        
        override var intrinsicContentSize: CGSize {
            contentSize ?? super.intrinsicContentSize
        }
        
        init(contentSize: CGSize? = nil) {
            self.contentSize = contentSize
            super.init(frame: .zero)
        }
        required init?(coder: NSCoder) { nil }
    }
}


#Preview {
    
    BirthDatePicker()
}

