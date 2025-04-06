//
//  DSLabelButton.swift
//  AlarmMission
//
//  Created by choijunios on 1/20/25.
//

import UIKit

import FeatureResources

public class DSLabelButton: TouchDetectingView {
    
    public enum Action {
        case onTapped
    }
    
    // Listener
    public var buttonAction: (() -> Void)?
    
    
    // Sub views
    private let titleLabel: UILabel = .init()
    
    
    // Configuration
    private var config: Config
    
    
    public init(config: Config) {
        self.config = config
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }

    public override func onTap(direction: TouchDetectingView.TapDirection) { buttonAction?() }
}


// MARK: Setup
private extension DSLabelButton {
    
    func setupUI() {
        addSubview(titleLabel)
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


// MARK: Public interface
public extension DSLabelButton {
    
    func update(titleText: String) {
        self.titleLabel.displayText = titleText.displayText(
            font: config.font,
            color: config.textColor
        )
    }
    
    func update(config: Config) {
        self.config = config
        self.titleLabel.displayText = titleLabel.displayText?.string.displayText(
            font: config.font,
            color: config.textColor
        )
    }
}


public extension DSLabelButton {
    
    struct Config {
        let font: R.Font
        let textColor: UIColor
        
        public init(font: R.Font, textColor: UIColor) {
            self.font = font
            self.textColor = textColor
        }
    }
}


#Preview {
    let view = DSLabelButton(config: .init(font: .body1Medium, textColor: .black))
    view.update(titleText: "안녕하세요")
    return view
}
