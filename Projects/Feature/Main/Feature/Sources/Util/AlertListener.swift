//
//  AlertListener.swift
//  Main
//
//  Created by choijunios on 2/12/25.
//

import FeatureDesignSystem

class AlertListener: DSTwoButtonAlertViewControllerListener {
    var leftTapped: (() -> Void)?
    var rightTapped: (() -> Void)?
    func action(_ action: DSTwoButtonAlertViewController.Action) {
        switch action {
        case .leftButtonClicked:
            leftTapped?()
        case .rightButtonClicked:
            rightTapped?()
        }
    }
}
