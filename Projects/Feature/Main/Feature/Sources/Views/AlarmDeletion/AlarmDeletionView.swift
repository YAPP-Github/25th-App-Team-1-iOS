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

protocol AlarmDeletionViewListener: AnyObject {
    func action(_ action: AlarmDeletionView.Action)
}

final class AlarmDeletionView: UIView, UIGestureRecognizerDelegate, AlarmDeletionItemViewListener {
    
    // Action
    enum Action {
        case deleteButtonClicked(cellId: String)
        case deletionItemToggleIsTapped(cellId: String)
        case backgroundTapped
    }
    
    
    // State
    private var alarmRO: AlarmCellRO?
    
    
    // Listener
    weak var listener: AlarmDeletionViewListener?
    
    
    // Sub view
    private let blurEffectView: UIVisualEffectView = .init()
    private let deletionItemView: AlarmDeletionItemView = .init()
    private let alarmDeleteButton: AlarmDeleteButton = .init()
    
    
    // Gesture
    private let tapGesture: UITapGestureRecognizer = .init()
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        setupGesture()
    }
    required init?(coder: NSCoder) { nil }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: deletionItemView) == true {
            return false
        }
        return true
    }
}


// MARK: Public interface
extension AlarmDeletionView {
    func present() {
        blurEffectView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.blurEffectView.alpha = 1
        }
    }
    
    func dismiss(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        } completion: { _ in completion?() }
    }
    func update(renderObject ro: AlarmCellRO) {
        self.alarmRO = ro
        deletionItemView.update(renderObject: ro)
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
            guard let cellId = self.alarmRO?.id else { return }
            listener?.action(.deleteButtonClicked(cellId: cellId))
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
        listener?.action(.backgroundTapped)
    }
}


// MARK: AlarmDeletionItemViewListener
extension AlarmDeletionView {
    func action(_ action: AlarmDeletionItemView.Action) {
        switch action {
        case .toggleIsTapped:
            guard let cellId = alarmRO?.id, let alarmRO else { break }
            listener?.action(.deletionItemToggleIsTapped(cellId: cellId))
            var newRO = alarmRO
            newRO.isToggleOn = !alarmRO.isToggleOn
            self.alarmRO = newRO
            deletionItemView.update(renderObject: newRO)
        }
    }
}
