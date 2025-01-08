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

final class BirthDayPicker: UIView {
    
    // Sub view
    private let calendarColumn: BirthDayPickerColumnView = {
        
        let selectionItemViewSize: CGSize = .init(width: 48, height: 38)
        
        let selectionItems = CalendarType.displayOrderList.map { calendarType in
            
            BirthDaySelectionItem(
                content: calendarType.content,
                displayingText: calendarType.displayKoreanText,
                contentSize: selectionItemViewSize
            )
        }
        
        let columnView = BirthDayPickerColumnView(
            itemSpacing: 12,
            items: selectionItems
        )
        
        columnView.updateCellUI { cellView in
            
            cellView
                .setTextStyle(font: .title2SemiBold, color: R.Color.white100)
                .setContentSize(selectionItemViewSize)
        }
        
        return columnView
    }()
    private let yearColumn: BirthDayPickerColumnView = {
        
        let selectionItemViewSize: CGSize = .init(width: 63, height: 38)
        
        let currentYear = Calendar.current.dateComponents([.year], from: .now).year!
        
        let selectionItems = (1900...currentYear).map { yearItem in
            
            BirthDaySelectionItem(
                content: String(yearItem),
                displayingText: String(yearItem),
                contentSize: selectionItemViewSize
            )
        }
        
        let columnView = BirthDayPickerColumnView(
            itemSpacing: 12,
            items: selectionItems
        )
        
        columnView.updateCellUI { cellView in
            
            cellView
                .setTextStyle(font: .title2SemiBold, color: R.Color.white100)
                .setContentSize(selectionItemViewSize)
        }
        
        return columnView
    }()
    private let monthColumn: BirthDayPickerColumnView = {
        
        let selectionItemViewSize: CGSize = .init(width: 40, height: 38)
        
        let selectionItems = (1...12).map { monthItem in
            
            BirthDaySelectionItem(
                content: String(monthItem),
                displayingText: String(monthItem),
                contentSize: selectionItemViewSize
            )
        }
        
        let columnView = BirthDayPickerColumnView(
            itemSpacing: 12,
            items: selectionItems
        )
        
        columnView.updateCellUI { cellView in
            
            cellView
                .setTextStyle(font: .title2SemiBold, color: R.Color.white100)
                .setContentSize(selectionItemViewSize)
        }
        
        return columnView
    }()
    private let dayColumn: BirthDayPickerColumnView = {
        
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
        
        let columnView = BirthDayPickerColumnView(
            itemSpacing: 12,
            items: selectionItems
        )
        
        columnView.updateCellUI { cellView in
            
            cellView
                .setTextStyle(font: .title2SemiBold, color: R.Color.white100)
                .setContentSize(selectionItemViewSize)
        }
        
        return columnView
    }()
    
    private let inBoundDisplayView: UIView = .init()
    private var gradientLayer: CALayer?
    
    
    // Listener
    weak var listener: AlarmPickerListener?
    
    
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
        
        Observable.combineLatest(
            calendarColumn.rx.selectedItem,
            yearColumn.rx.selectedItem,
            monthColumn.rx.selectedItem,
            dayColumn.rx.selectedItem
        ).subscribe(onNext: { [weak self] calendarType, year, month, day in
            
            guard let self else { return }
            
            
        })
        .disposed(by: disposeBag)
    }
}


// MARK: Public interface
extension BirthDayPicker {
    
    func updateToNow() {
        
    }
}


// MARK: Gradient
private extension BirthDayPicker {
    
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
    
    BirthDayPicker()
}

