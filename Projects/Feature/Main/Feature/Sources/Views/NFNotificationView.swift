//
//  NFNotificationView.swift
//  FeatureMain
//
//  Created by choijunios on 9/7/25.
//

import RIBs
import RxSwift
import UIKit
import FeatureResources
import FeatureDesignSystem
import SnapKit

protocol NFNotificationViewListener: AnyObject {
    func action(_ action: NFNotificationViewAction)
}

enum NFNotificationViewAction {
    case backgroundTapped
    case closeButtonTapped
    case dontShowAgainButtonTapped
}

final class NFNotificationView: UIView {
    
    private lazy var dimmedBackgroundView: UIView = .init()
    private lazy var containerView: UIView = .init()
    private lazy var imageGuideView: UIImageView = .init()
    private lazy var buttonStack: UIStackView = .init()
    private lazy var dontShowAgainButton: DSLabelButton = .init(config: .init(font: .body1SemiBold, textColor: R.Color.white100, alignment: .center))
    private lazy var closeButton: DSLabelButton = .init(config: .init(font: .body1SemiBold, textColor: R.Color.white100, alignment: .center))
    
    // Gesture
    private let backgroundTapGesture: UITapGestureRecognizer = .init()

    // Listener
    weak var listener: NFNotificationViewListener?
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        setupGesture()
    }
    required init?(coder: NSCoder) { nil }
}

private extension NFNotificationView {
    func setupUI() {
        // dimmedBackgroundView
        dimmedBackgroundView.backgroundColor = R.Color.dimmed.withAlphaComponent(0.8)
        dimmedBackgroundView.addGestureRecognizer(backgroundTapGesture)
        self.addSubview(dimmedBackgroundView)
        
        // containerView
        self.addSubview(containerView)
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = R.Color.gray800
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // imageGuideView
        imageGuideView.clipsToBounds = true
        imageGuideView.contentMode = .scaleAspectFit
        containerView.addSubview(imageGuideView)
        
        // buttonStack
        containerView.addSubview(buttonStack)
        [dontShowAgainButton, closeButton].forEach {
            buttonStack.addArrangedSubview($0)
        }
        
        // dontShowAgainButton
        dontShowAgainButton.update(titleText: "다시보지 않기")
        dontShowAgainButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.dontShowAgainButtonTapped)
        }
        
        // closeButton
        closeButton.update(titleText: "닫기")
        closeButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.closeButtonTapped)
        }
    }
    
    func setupLayout() {
        // dimmedBackgroundView
        dimmedBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // containerView
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // imageGuideView
        imageGuideView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        // buttonStack
        buttonStack.axis = .horizontal
        buttonStack.spacing = 10
        buttonStack.distribution = .fillEqually
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(imageGuideView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.height.equalTo(54)
        }
    }
    
    func setupGesture() {
        backgroundTapGesture.addTarget(self, action: #selector(onBackgroundTapGestureTapped(_:)))
    }
    
    @objc
    func onBackgroundTapGestureTapped(_ gesture: UITapGestureRecognizer) {
        listener?.action(.backgroundTapped)
    }
}

extension NFNotificationView {
    func present(image: UIImage) {
        imageGuideView.image = image
        let aspect = image.size.height / image.size.width
        imageGuideView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageGuideView.snp.width).multipliedBy(aspect)
        }
        self.setNeedsLayout()
    }
    
    func startPresentationAnimation(duration: TimeInterval, completion: @escaping () -> Void) {
        // #1. Initial State
        self.alpha = 0
        
        // #2. Animate
        UIView.animate(withDuration: duration) {
            self.alpha = 1
        } completion: { _ in
            completion()
        }
    }
    
    func startDismissalAnimation(duration: TimeInterval, completion: @escaping () -> Void) {
        // #1. Animate
        UIView.animate(withDuration: duration) {
            self.dimmedBackgroundView.alpha = 0
            self.containerView.layer.frame.origin.y = UIScreen.main.bounds.height
        } completion: { _ in
            completion()
        }
    }
}
