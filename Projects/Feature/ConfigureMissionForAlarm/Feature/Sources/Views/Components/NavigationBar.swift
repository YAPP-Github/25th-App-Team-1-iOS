//
//  NavigationBar.swift
//  ConfigureMissionForAlarm
//
//  Created by choijunios on 7/31/25.
//

import UIKit

import FeatureResources
import FeatureUIDependencies

final class NavigationBar: UIView {
    
    // Action
    enum Action {
        case exitButtonTapped
        case prevButtonTapped
    }
    var action: ((Action) -> ())?
    
    
    // UI
    private let prevButton: DSDefaultIconButton = .init(
        style: .init(
            type: .default,
            image: FeatureResourcesAsset.chevronLeft.image,
            size: .medium
        )
    )
    private let exitButton: DSDefaultIconButton = .init(
        style: .init(
            type: .default,
            image: FeatureResourcesAsset.xmark.image,
            size: .small
        )
    )
    private let appBar: DSAppBar = .init()
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    
    private func setupUI() {
        // self
        self.backgroundColor = R.Color.gray800
        
        
        // appBar
        appBar.insertLeftView(prevButton)
        appBar.insertRightView(exitButton)
        addSubview(appBar)
        
        // prevButton
        prevButton.buttonAction = { [unowned self] in
            action?(.prevButtonTapped)
        }
        
        
        // exitButton
        exitButton.buttonAction = { [unowned self] in
            action?(.exitButtonTapped)
        }
    }
    
    
    private func setupLayout() {
        
        // appBar
        appBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    func update(title: String) {
        appBar.update(titleText: title)
    }
}
