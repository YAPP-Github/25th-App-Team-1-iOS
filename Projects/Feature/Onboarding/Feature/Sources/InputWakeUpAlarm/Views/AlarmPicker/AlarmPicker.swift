//
//  AlarmPicker.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/6/25.
//

import UIKit

import FeatureResources

import SnapKit
import RxSwift

protocol AlarmPickerListener: AnyObject {
    
    func latestSelection(meridiem: String, hour: Int, minute: Int)
}

class AlarmPicker: UIView {
    
    // Sub view
    private let meridiemColumn: AlarmPickerColumnView = {
        
        let selectionItemViewSize: CGSize = .init(width: 48, height: 38)
        
        let selectionItems = MeridiemItem.allCases.map { item in
            
            SelectionItem(
                content: item.content,
                displayingText: item.displayingText,
                contentSize: selectionItemViewSize
            )
        }
        
        let columnView = AlarmPickerColumnView(
            itemSpacing: 12,
            items: selectionItems
        )
        
        columnView.updateCellUI { cellView in
            
            cellView
                .setTextStyle(font: .title2Medium, color: R.Color.white100)
                .setContentSize(selectionItemViewSize)
        }
        
        return columnView
    }()
    private let hourColumn: AlarmPickerColumnView = {
        
        let selectionItemViewSize: CGSize = .init(width: 48, height: 48)
        
        let selectionItems = (1...12).map { hour in
            
            SelectionItem(
                content: String(hour),
                displayingText: "\(hour)",
                contentSize: selectionItemViewSize
            )
        }
        
        let columnView = AlarmPickerColumnView(
            itemSpacing: 12,
            items: selectionItems
        )
        
        columnView.updateCellUI { cellView in
            
            cellView
                .setTextStyle(font: .title2Medium, color: R.Color.white100)
                .setContentSize(selectionItemViewSize)
        }
        
        return columnView
    }()
    private let minuteColumn: AlarmPickerColumnView = {
        
        let selectionItemViewSize: CGSize = .init(width: 48, height: 48)
        
        let selectionItems = (1...60).map { minute in
            
            var displayingText = "\(minute)"
            
            if minute < 10 {
                
                displayingText = "0\(minute)"
            }
            
            return SelectionItem(
                content: String(minute),
                displayingText: displayingText,
                contentSize: selectionItemViewSize
            )
        }
        
        let columnView = AlarmPickerColumnView(
            itemSpacing: 12,
            items: selectionItems
        )
        
        columnView.updateCellUI { cellView in
            
            cellView
                .setTextStyle(font: .title2Medium, color: R.Color.white100)
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
            meridiemColumn,
            UIStackView.Spacer(contentSize: .init(width: 40, height: 0)),
            hourColumn,
            UIStackView.Spacer(contentSize: .init(width: 30, height: 0)),
            minuteColumn
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
            meridiemColumn.rx.selectedItem,
            hourColumn.rx.selectedItem,
            minuteColumn.rx.selectedItem
        ).subscribe(onNext: { [weak self] meridiem, hour, minute in
            guard let self else { return }
            
            listener?.latestSelection(
                meridiem: meridiem.content,
                hour: Int(hour.content)!,
                minute: Int(minute.content)!
            )
        })
        .disposed(by: disposeBag)
    }
}


// MARK: Public interface
extension AlarmPicker {
    
    func update(meridiem: MeridiemItem? = nil, hour: Int? = nil, minute: Int? = nil) {
        
        if let meridiem {
            
            let content = meridiem.content
            meridiemColumn.rx.setContent.accept(content)
        }
        
        
        if let hour, (1...12).contains(hour) {
            
            let content = String(hour)
            hourColumn.rx.setContent.accept(content)
        }
        
        
        if let minute, (0...60).contains(minute) {
            
            let content = String(minute)
            minuteColumn.rx.setContent.accept(content)
        }
    }
    
    
    func updateToNow() {
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: .now)
        
        guard var hour = dateComponents.hour, let minute = dateComponents.minute else { return }
        
        var meridiem: MeridiemItem = .ante
        
        if hour >= 12 {
            meridiem = .post
            hour -= 12
        }
        
        self.update(meridiem: meridiem, hour: hour, minute: minute)
    }
}


// MARK: Gradient
private extension AlarmPicker {
    
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
    
    AlarmPicker()
}
