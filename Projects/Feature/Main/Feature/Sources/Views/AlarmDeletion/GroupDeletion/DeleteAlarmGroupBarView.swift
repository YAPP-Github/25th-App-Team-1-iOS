//
//  DeleteAlarm.swift
//  Main
//
//  Created by choijunios on 2/7/25.
//

import UIKit

import FeatureDesignSystem
import FeatureResources

import SnapKit
import Then

protocol DeleteAlarmGroupBarViewListener: AnyObject {
    func action(_ action: DeleteAlarmGroupBarView.Action)
}


final class DeleteAlarmGroupBarView: UIView {
    // Action
    enum Action {
        case cancelButtonTapped
        case selectAllButtonTapped
    }
    
    
    // Listener
    weak var listener: DeleteAlarmGroupBarViewListener?
    
    
    // Sub view
    private let checkBox: DSCheckBox = .init(initialState: .idle, buttonStyle: .init(size: .medium))
    private let titleLabel: UILabel = .init()
    private let selectAllStackView: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.spacing = 22
        $0.alignment = .center
    }
    
    private let cancelButton: DSDefaultIconButton = .init(style: .init(
        type: .default,
        image: FeatureResourcesAsset.xmark.image,
        size: .medium
    ))
    
    private let contentContainer: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.alignment = .center
    }
    
    
    // Gesture
    private let selectAllButtonTapGesture = UITapGestureRecognizer()
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        setupGesture()
    }
    required init?(coder: NSCoder) { nil }
}


// MARK: Public interface
extension DeleteAlarmGroupBarView {
    func update(isDeleteAllCheckBoxChecked: Bool) {
        checkBox.update(state: isDeleteAllCheckBoxChecked ? .seleceted : .idle)
    }
}


private extension DeleteAlarmGroupBarView {
    func setupUI() {
        // self
        self.backgroundColor = .clear
        
        
        // titleLabel
        titleLabel.displayText = "전체 선택".displayText(font: .heading2SemiBold, color: R.Color.white100)
        
            
        // firstStack
        [checkBox, titleLabel].forEach {
            selectAllStackView.addArrangedSubview($0)
        }
        
        // cancelButton
        cancelButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.cancelButtonTapped)
        }
        
        // contentContainer
        [selectAllStackView, UIView(), cancelButton].forEach {
            contentContainer.addArrangedSubview($0)
        }
        addSubview(contentContainer)
    }
    
    func setupLayout() {
        // contentContainer
        contentContainer.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(24)
            make.right.equalToSuperview().inset(16)
        }
    }
    
    func setupGesture() {
        selectAllStackView.addGestureRecognizer(selectAllButtonTapGesture)
        selectAllButtonTapGesture.addTarget(self, action: #selector(tapSelectAllButton(_:)))
    }
    @objc
    func tapSelectAllButton(_ sender: UITapGestureRecognizer) {
        listener?.action(.selectAllButtonTapped)
    }
}


#Preview {
    DeleteAlarmGroupBarView()
}
