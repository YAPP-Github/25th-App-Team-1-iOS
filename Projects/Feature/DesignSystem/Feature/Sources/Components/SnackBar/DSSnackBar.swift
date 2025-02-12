//
//  DSSnackBar.swift
//  DesignSystem
//
//  Created by choijunios on 2/12/25.
//

import UIKit

import FeatureResources
import FeatureThirdPartyDependencies

public final class DSSnackBar: UIView {
    // State
    private let status: SnackBarStatus
    
    
    // Sub views
    private let iconImageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let labelButton: DSLabelButton = .init(config: .init(
        font: .label2regular,
        textColor: R.Color.gray50
    ))
    private let containerStack: UIStackView = .init()
    
    
    public init(status: SnackBarStatus) {
        self.status = status
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    public required init?(coder: NSCoder) { nil }
}


// MARK: Setup
private extension DSSnackBar {
    func setupUI() {
        // self
        self.backgroundColor = R.Color.gray600
        self.layer.cornerRadius = 12
        
        // iconImage
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = status.iconImage
        
        // labelButton
        labelButton.isHidden = true
        
        // containerStack
        containerStack.axis = .horizontal
        containerStack.alignment = .center
        containerStack.spacing = 6
        [iconImageView, titleLabel, UIView(), labelButton].forEach {
            containerStack.addArrangedSubview($0)
        }
        addSubview(containerStack)
    }
    
    func setupLayout() {
        // containerStack
        containerStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(14)
            make.right.equalToSuperview().inset(16)
        }
    }
}


// MARK: Public interface
public extension DSSnackBar {
    @discardableResult
    func update(titleText: String) -> Self {
        self.titleLabel.displayText = titleText.displayText(font: .label1Medium, color: R.Color.white100)
        return self
    }
    @discardableResult
    func update(dismissButtonTitleText: String) -> Self {
        labelButton.isHidden = false
        labelButton.update(titleText: dismissButtonTitleText)
        labelButton.buttonAction = { [weak self] in
            guard let self else { return }
            
        }
        return self
    }
    
    func play() {
        superview?.layoutIfNeeded()
        let height = self.layer.bounds.height
        self.transform = .init(translationX: 0, y: height)
        self.alpha = 0
        self.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.35) {
            self.transform = .identity
            self.alpha = 1
        } completion: { _ in
            self.isUserInteractionEnabled = true
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in
                guard let self else { return }
                
                UIView.animate(withDuration: 0.35) {
                    self.transform = .init(translationX: 0, y: height)
                    self.alpha = 0
                } completion: { _ in
                    self.alpha = 0
                    self.removeFromSuperview()
                }
            }
        }
    }
    
    enum SnackBarStatus {
        case success
        case failure
        
        var iconImage: UIImage {
            switch self {
            case .success:
                FeatureResourcesAsset.checkCircleFill.image
            case .failure:
                FeatureResourcesAsset.alertCircle.image
            }
        }
    }
}


#Preview {
    let snackBar = DSSnackBar(status: .success)
        .update(titleText: "안녕하세요~")
        .update(dismissButtonTitleText: "닫기")
    snackBar.alpha = 0
    DispatchQueue.main.async {
        snackBar.play()
    }
    return snackBar
}
