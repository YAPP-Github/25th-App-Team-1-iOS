//
//  AlarmPicker.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/6/25.
//

import UIKit

import FeatureResources

import SnapKit

class AlarmPicker: UIView {
    
    
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
    
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    
    private func setupUI() {
        
        self.backgroundColor = .blue
    }
    
    
    private func setupLayout() {
        
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
        
        columnStackView.backgroundColor = .red
        
        addSubview(columnStackView)
        columnStackView.snp.makeConstraints { make in
            
            make.center.equalToSuperview()
        }
    }
}

enum MeridiemItem: CaseIterable {
    
    case ante
    case post
    
    var content: String {
        
        switch self {
        case .ante:
            "AM"
        case .post:
            "PM"
        }
    }
    
    var displayingText: String {
        switch self {
        case .ante:
            "오전"
        case .post:
            "오후"
        }
    }
}


// MARK: UIStackView+Spacer
extension UIStackView {
        
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
