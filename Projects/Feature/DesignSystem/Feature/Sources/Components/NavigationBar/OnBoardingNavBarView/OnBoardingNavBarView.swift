//
//  OnBoardingNavBarView.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/4/25.
//

import UIKit

import FeatureResources

import FeatureThirdPartyDependencies

public protocol OnBoardingNavBarViewListener: AnyObject {
    
    func action(_ action: OnBoardingNavBarView.Action)
}


public final class OnBoardingNavBarView: UIView {
    
    // View actions
    public enum Action {
        case backButtonClicked
        case rightButtonClicked
    }
    
    // Listener
    public weak var listener: OnBoardingNavBarViewListener?
    
    // Sub view
    private let backButton: UIButton = .init().then {
        let buttonImage =  FeatureResourcesAsset.chevronLeft.image
        $0.setImage(buttonImage, for: .normal)
    }
    
    private let rightButton: UIButton = .init()
    private let titleLabel = UILabel()
    fileprivate let stageIndexView: StageIndexView = .init()
        
    public override var intrinsicContentSize: CGSize {
        return .init(width: UIView.noIntrinsicMetric, height: 56)
    }
         
    public init() {
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    public func update(title: String) {
        titleLabel.displayText = title.displayText(font: .body1SemiBold, color: R.Color.white100)
    }
    
    public func update(rightButtonTitle: NSAttributedString) {
        rightButton.setAttributedTitle(rightButtonTitle, for: .normal)
        rightButton.isHidden = false
    }
    
    public func setIndex(_ currentStage: Int, of stageCount: Int) {
        stageIndexView.isHidden = false
        stageIndexView.update(currentStage: currentStage, stageCount: stageCount)
    }
    
    @objc
    private func backButtonClicked() {
        
        listener?.action(.backButtonClicked)
        
        backButton.imageView?.alpha = 0.5
        UIView.animate(withDuration: 0.35) {
        
            self.backButton.imageView?.alpha = 1
        }
    }
    
    @objc
    private func rightButtonClicked() {
        listener?.action(.rightButtonClicked)
        
        backButton.alpha = 0.5
        UIView.animate(withDuration: 0.35) {
            self.backButton.alpha = 1
        }
    }
    
    
    private func setupUI() {
        self.backgroundColor = .clear
        stageIndexView.isHidden = true
        backButton.addTarget(self,
            action: #selector(backButtonClicked),
            for: .touchUpInside)
        rightButton.addTarget(self,
            action: #selector(rightButtonClicked),
            for: .touchUpInside)
        rightButton.isHidden = true
    }
    
    
    private func setupLayout() {
        [backButton, titleLabel, rightButton, stageIndexView].forEach {
            addSubview($0)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalTo(20)
            $0.size.equalTo(32)
            $0.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        stageIndexView.snp.makeConstraints {
            $0.trailing.equalTo(-20)
            $0.centerY.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.trailing.equalTo(-18)
            $0.centerY.equalToSuperview()
        }
    }
    
}


#Preview {
    
    let view = OnBoardingNavBarView()
    
    view.stageIndexView.update(currentStage: 4, stageCount: 6)
    view.backgroundColor = R.Color.gray900
    
    return view
}
