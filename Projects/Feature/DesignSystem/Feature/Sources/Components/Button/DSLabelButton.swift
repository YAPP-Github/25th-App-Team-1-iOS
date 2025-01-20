//
//  DSLabelButton.swift
//  AlarmMission
//
//  Created by choijunios on 1/20/25.
//

import UIKit

import FeatureResources

protocol LabelButtonListener: AnyObject {
    func action(_ action: DSLabelButton.Action)
}

class DSLabelButton: TouchDetectingView {
    
    enum Action {
        case onTapped
    }
    
    // Listener
    weak var listener: LabelButtonListener?
    
    
    // Sub views
    private let titleLabel: UILabel = .init()
    
    
    // Configuration
    let config: Config
    
    
    init(config: Config) {
        self.config = config
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { nil }
    
    
    override func onTouchOut() {
        listener?.action(.onTapped)
    }
}


// MARK: Public interface
extension LabelButton {
    
    func update(titleText: String) {
        self.titleLabel.displayText = titleText.displayText(
            font: .body1SemiBold,
            color: .white
        )
    }
}


extension LabelButton {
    
    struct Config {
        let font: R.Font
        let textColor: UIColor
    }
}
