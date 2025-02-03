//
//  AlarmPicker.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/6/25.
//

import UIKit

import FeatureResources
import FeatureCommonEntity

import SnapKit
import RxSwift

public protocol AlarmPickerListener: AnyObject {
    func latestSelection(meridiem: Meridiem, hour: Hour, minute: Minute)
}

public final class AlarmPicker: UIView {
    private let meridiemColumns: [Meridiem] = [.am, .pm]
    private var hourColumns: [Hour] = (1...12).compactMap { Hour($0) }
    private let minuteColumns: [Minute] = (0...59).compactMap { Minute($0) }
    
    // Sub view
    private lazy var meridiemColumnView: AlarmPickerColumnView = {
        
        let selectionItemViewSize: CGSize = .init(width: 48, height: 38)
        
        let columnView = AlarmPickerColumnView(
            itemSpacing: 12,
            items: meridiemColumns
        )
        
        columnView.updateCellUI { cellView in
            cellView
                .setTextStyle(font: .title2Medium, color: R.Color.white100)
                .setContentSize(selectionItemViewSize)
        }
        
        return columnView
    }()
    private lazy var hourColumnView: AlarmPickerColumnView = {
        
        let selectionItemViewSize: CGSize = .init(width: 48, height: 38)
        
        let columnView = AlarmPickerColumnView(
            itemSpacing: 12,
            items: hourColumns
        )
        
        columnView.updateCellUI { cellView in
            cellView
                .setTextStyle(font: .title2Medium, color: R.Color.white100)
                .setContentSize(selectionItemViewSize)
        }
        
        return columnView
    }()
    private lazy var minuteColumnView: AlarmPickerColumnView = {
        
        let selectionItemViewSize: CGSize = .init(width: 48, height: 38)
        let columnView = AlarmPickerColumnView(
            itemSpacing: 12,
            items: minuteColumns
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
    public weak var listener: AlarmPickerListener?
    
    // Rx
    private let disposeBag: DisposeBag = .init()
    
    public init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        setReactive()
    }
    required init?(coder: NSCoder) { nil }
   
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if let gradientLayer {
            gradientLayer.frame = self.bounds
        } else {
            createGradientLayer()
        }
    }
    
    private func setupUI() {
        // self
        self.backgroundColor = R.Color.gray900
        
        // inBoundDisplayView
        inBoundDisplayView.backgroundColor = R.Color.gray700
        inBoundDisplayView.layer.cornerRadius = 12
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
            meridiemColumnView,
            UIStackView.Spacer(contentSize: .init(width: 40, height: 0)),
            hourColumnView,
            UIStackView.Spacer(contentSize: .init(width: 30, height: 0)),
            minuteColumnView
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
            meridiemColumnView.rx.selectedItem,
            hourColumnView.rx.selectedItem,
            minuteColumnView.rx.selectedItem
        ).subscribe(onNext: { [weak self] meridiem, hour, minute in
            guard let self,
                  let meridiem = meridiem as? Meridiem,
                  let hour = hour as? Hour,
                  let minute = minute as? Minute
            else { return }
            listener?.latestSelection(
                meridiem: meridiem,
                hour: hour,
                minute: minute
            )
        })
        .disposed(by: disposeBag)
    }
}


// MARK: Public interface
public extension AlarmPicker {
    
    func update(meridiem: Meridiem? = nil, hour: Hour? = nil, minute: Minute? = nil) {
        
        if let meridiem {
            
            let content = meridiem.toKoreanFormat
            meridiemColumnView.rx.setContent.accept(content)
        }
        
        
        if let hour {
            let content = "\(hour.value)"
            hourColumnView.rx.setContent.accept(content)
        }
        
        
        if let minute {
            let content = "\(minute.value)"
            minuteColumnView.rx.setContent.accept(content)
        }
    }
    
    
    func updateToNow() {
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: .now)
        guard let hourValue = dateComponents.hour,
              let hour = Hour(hourValue) else { return }
        guard let minuteValue = dateComponents.minute,
              let minute = Minute(minuteValue) else { return }
        
        let meridiem: Meridiem = hourValue < 12 ? .am : .pm
        
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
