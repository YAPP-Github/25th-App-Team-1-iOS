//
//  OnBoardingNavBarView.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/4/25.
//

import UIKit

import FeatureResources

import SnapKit
import Then

public protocol OnBoardingNavBarViewListener: AnyObject {
    
    func action(_ action: OnBoardingNavBarView.Action)
}


public final class OnBoardingNavBarView: UIView {
    
    // View actions
    public enum Action {
        
        case backButtonClicked
    }
    
    
    // Listener
    public weak var listener: OnBoardingNavBarViewListener?
    
    
    // Sub view
    private let backButton: UIButton = .init().then {
        let buttonImage =  FeatureResourcesAsset.chevronLeft.image
        $0.setImage(buttonImage, for: .normal)
    }
    fileprivate let stageIndexView: StageIndexView = .init()
        
         
    public init() {
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    
    @objc
    private func backButtonClicked() {
        
        listener?.action(.backButtonClicked)
        
        backButton.imageView?.alpha = 0.5
        UIView.animate(withDuration: 0.35) {
        
            self.backButton.imageView?.alpha = 1
        }
    }
    
    
    private func setupUI() {
        self.backgroundColor = .clear
        
        backButton.addTarget(self,
            action: #selector(backButtonClicked),
            for: .touchUpInside)
    }
    
    
    private func setupLayout() {
        
        let stackView: UIStackView = .init(arrangedSubviews: [
            backButton, UIView(), stageIndexView
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
}


#Preview {
    
    let view = OnBoardingNavBarView()
    
    view.stageIndexView.update(currentStage: 4, stageCount: 6)
    view.backgroundColor = R.Color.gray900
    
    return view
}
