//
//  BirthDayPicker.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import UIKit

import FeatureResources

import SnapKit
import RxSwift

protocol BirthDatePickerListener: AnyObject {
    
    func latestDate(calendar: CalendarType, year: Int, month: Int, day: Int)
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
        let selectionItems = (1900...currentYear).map { yearItem in
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
                
                let (calendar, year, month) = bundle
                
                var calendarType: CalendarType!
                
                switch calendar {
                case CalendarType.lunar.content:
                    calendarType = .lunar
                case CalendarType.gregorian.content:
                    calendarType = .gregorian
                default:
                    fatalError()
                }
                
                guard let yearInt = Int(year), let monthInt = Int(month) else {
                    fatalError()
                }
                
                let newDayRange = view.updateDay(calendarType: calendarType, year: yearInt, month: monthInt)
                
                return (calendar, year, month, newDayRange)
            })
        
        
        // 일의 변화를 관찰
        let dayChangeObservable = dayColumn.rx.selectedContent.distinctUntilChanged()
        
        Observable
            .combineLatest(dateIsUpdated, dayChangeObservable)
            .subscribe(onNext: { [weak self] bundle, day in
                
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
                
                guard let yearInt = Int(year), let monthInt = Int(month), let dayInt = Int(day) else {
                    fatalError()
                }
                
                // 업데이트된 일수를 적용하여 현재 방출된 Day값이 유효한지 확인
                if newDayRange.contains(dayInt) {
                    
                    // 현재 방출된 일 값이 유효함
                    
                    listener?.latestDate(calendar: calendarType, year: yearInt, month: monthInt, day: dayInt)
                }
            })
            .disposed(by: disposeBag)
    }
}


// MARK: Public interface
extension BirthDatePicker {
    
    func updateToNow() {
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        
        guard let year = dateComponents.year, let month = dateComponents.month, let day = dateComponents.day else { return }
        
        let calendarType: CalendarType = .gregorian
        
        // update picker
        update(calendarType: calendarType, year: year, month: month, day: day)
    }
    
    
    func update(calendarType: CalendarType, year: Int, month: Int, day: Int) {
        
        // calendarType
        calendarColumn.rx.setContent.accept(calendarType.content)
        
        // year
        yearColumn.rx.setContent.accept(String(year))
        
        // month
        monthColumn.rx.setContent.accept(String(month))
        
        // day
        updateDay(calendarType: calendarType, year: year, month: month)
        dayColumn.rx.setContent.accept(String(day))
    }
    
    
    /// 새롭게 업데이트되는 일수를 반환
    @discardableResult
    func updateDay(calendarType: CalendarType, year: Int, month: Int) -> Range<Int> {
        
        let calendar = Calendar(identifier: calendarType.calendarIdentifier)
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        
        let updatedItems: [BirthDaySelectionItem] = range.map { dayItem in
            
            var displayingText = "\(dayItem)"
            
            if dayItem < 10 {
                
                displayingText = "0\(dayItem)"
            }
            
            let selectionItemViewSize: CGSize = .init(width: 42, height: 38)
            
            return BirthDaySelectionItem(
                content: String(dayItem),
                displayingText: displayingText,
                contentSize: selectionItemViewSize
            )
        }
        
        dayColumn.update(items: updatedItems)
        
        return range
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

