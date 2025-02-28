//
//  AlarmDeletionView.swift
//  Main
//
//  Created by choijunios on 2/1/25.
//

import UIKit

import FeatureResources
import FeatureThirdPartyDependencies
import FeatureCommonDependencies

final class AlarmDeletionView: UIView, UIGestureRecognizerDelegate, AlarmDeletionItemViewListener {
    
    // Action
    enum Action {
        case deleteButtonClicked
        case deletionItemToggleIsTapped
        case backgroundTapped
    }
    
    
    // Sub view
    private let blurEffectView: UIVisualEffectView = .init()
    private let deletionItemView: AlarmDeletionItemView = .init()
    private let alarmDeleteButton: AlarmDeleteButton = .init()
    
    
    // Gesture
    private let tapGesture: UITapGestureRecognizer = .init()
    
    
    // Action
    var action: ((AlarmDeletionView.Action) -> Void)?
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        setupGesture()
    }
    required init?(coder: NSCoder) { nil }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchedView = touch.view
        return touchedView === blurEffectView
    }
}


// MARK: Public interface
extension AlarmDeletionView {
    enum Update {
        case present
        case dismiss(completion: (() -> Void)?)
        case renderObject(AlarmCellRO)
    }
    
    @discardableResult
    func update(_ update: Update) -> Self {
        switch update {
        case .present:
            blurEffectView.alpha = 0
            UIView.animate(withDuration: 0.2) {
                self.blurEffectView.alpha = 1
            }
        case .dismiss(let completion):
            UIView.animate(withDuration: 0.2) {
                self.alpha = 0
            } completion: { _ in completion?() }
        case .renderObject(let alarmCellRO):
            deletionItemView.update(renderObject: alarmCellRO)
        }
        return self
    }
}


// MARK: Setup
private extension AlarmDeletionView {
    func setupUI() {
        // self
        self.backgroundColor = .clear
        
        // blurEffectView
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView.effect = blurEffect
        blurEffectView.alpha = 0.9
        addSubview(blurEffectView)
        
        // deletionItemView
        deletionItemView.listener = self
        addSubview(deletionItemView)
        
        // alarmDeleteButton
        alarmDeleteButton.buttonAction = { [weak self] in
            guard let self else { return }
            action?(.deleteButtonClicked)
        }
        addSubview(alarmDeleteButton)
    }
    
    func setupLayout() {
        // blurEffect
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // deletionItemView
        deletionItemView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(204)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        // alarmDeleteButton
        alarmDeleteButton.snp.makeConstraints { make in
            make.centerX.equalTo(deletionItemView)
            make.top.equalTo(deletionItemView.snp.bottom).offset(20)
        }
    }
    
    func setupGesture() {
        // tapGesture
        self.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(onTapBackground(gesture:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
    }
    @objc
    func onTapBackground(gesture: UITapGestureRecognizer) {
        action?(.backgroundTapped)
    }
}


// MARK: AlarmDeletionItemViewListener
extension AlarmDeletionView {
    func action(_ action: AlarmDeletionItemView.Action) {
        switch action {
        case .toggleIsTapped:
            self.action?(.deletionItemToggleIsTapped)
        }
    }
}
