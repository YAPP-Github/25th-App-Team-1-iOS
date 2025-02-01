//
//  DateItemButton.swift
//  FeatureAlarm
//
//  Created by ever on 1/20/25.
//

import UIKit
import FeatureResources
import SnapKit
import Then

final class DateItemButton: UIButton {
    private let normalBackgroundColor = R.Color.gray700
    private let disabledBackgroundColor = R.Color.gray600
    private let selectedBackgroundColor = R.Color.main10
    private let selectedBorderColor = R.Color.main20.cgColor
    
    private var title: String = ""
    private var buttonState: State = .normal
    
    func update(title: String) {
        self.title = title
        update()
    }
    
    func update(state: State) {
        self.buttonState = state
        update()
    }
    
    private func update() {
        switch buttonState {
        case .normal:
            setAttributedTitle(title.displayText(font: .body1Medium, color: R.Color.gray300), for: .normal)
            backgroundColor = normalBackgroundColor
            layer.borderWidth = 0
        case .disabled:
            setAttributedTitle(title.displayText(font: .body1Medium, color: R.Color.gray300), for: .normal)
            backgroundColor = disabledBackgroundColor
            layer.borderWidth = 0
        case .selected:
            backgroundColor = selectedBackgroundColor
            setAttributedTitle(title.displayText(font: .body1Medium, color: R.Color.main100), for: .normal)
            layer.borderColor = selectedBorderColor
            layer.borderWidth = 1
        }
    }
}

extension DateItemButton {
    enum State {
        case normal
        case disabled
        case selected
    }
}
