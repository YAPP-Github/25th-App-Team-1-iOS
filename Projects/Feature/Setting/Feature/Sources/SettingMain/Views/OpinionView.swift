//
//  OpinionView.swift
//  Setting
//
//  Created by choijunios on 2/13/25.
//

import UIKit

import FeatureUIDependencies
import FeatureCommonDependencies

protocol OpinionViewListener: AnyObject {
    func action(_ action: OpinionView.Action)
}

final class OpinionView: UIView {
    // Action
    enum Action {
        case sendOpinionButtonClicked
    }
    
    
    // Listener
    weak var listener: OpinionViewListener?
    
    
    // Sub views
    private let titleLabel: UILabel = .init()
    private let opinionButton: OpinionButton = .init()
    private let firstColumnView: UIStackView = .init()
    private let orbitImageView: UIImageView = .init()
    private let contentStack: UIStackView = .init()
    
    private let mainContainerStack: UIStackView = .init()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
}


// MARK: Setup
private extension OpinionView {
    func setupUI() {
        //
        self.backgroundColor = R.Color.gray900
        
        
        // titleLabel
        titleLabel.numberOfLines = 2
        titleLabel.displayText = "오르비는 여러분과 함께\n성장해요!".displayText(
            font: .heading2SemiBold,
            color: R.Color.gray100
        )
        
        
        // opinionButton
        opinionButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.sendOpinionButtonClicked)
        }
        
        
        // firstColumnView
        firstColumnView.axis = .vertical
        firstColumnView.spacing = 12
        firstColumnView.alignment = .leading
        [titleLabel, opinionButton].forEach {
            firstColumnView.addArrangedSubview($0)
        }
        
        
        // orbitImageView
        orbitImageView.image = FeatureResourcesAsset.orbitOpinion.image
        orbitImageView.contentMode = .scaleAspectFit
        
        
        // contentStack
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        [SpacerView(width: 24), firstColumnView, UIView(), orbitImageView, SpacerView(width: 24)].forEach {
            contentStack.addArrangedSubview($0)
        }
        
        
        // mainContainerStack
        mainContainerStack.axis = .vertical
        mainContainerStack.distribution = .fill
        [
            contentStack,
            SpacerView(height: 20).update(color: .clear),
            SpacerView(height: 8).update(color: R.Color.gray800),
            SpacerView(height: 8).update(color: .clear),
        ].forEach {
            mainContainerStack.addArrangedSubview($0)
        }
        addSubview(mainContainerStack)
    }
    
    func setupLayout() {
        // orbitImageView
        orbitImageView.snp.makeConstraints { make in
            make.width.height.equalTo(120)
        }
        
        
        // mainContainerStack
        mainContainerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

#Preview {
    OpinionView()
}
