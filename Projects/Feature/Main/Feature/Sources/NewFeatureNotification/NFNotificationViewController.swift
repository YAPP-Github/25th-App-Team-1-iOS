//
//  NFNotificationViewController.swift
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

protocol NFNotificationPresentableListener: AnyObject {
    func request(_ request: NFNotificationPresentableListenerRequest)
}

enum NFNotificationPresentableListenerRequest {
    case viewDidLoad
    case closeButtonTapped
    case dontShowAgainButtonTapped
}

final class NFNotificationViewController: UIViewController, NFNotificationPresentable, NFNotificationViewControllable {
    
    private lazy var containerView: UIView = .init()
    private lazy var imageGuideView: UIImageView = .init()
    private lazy var buttonStack: UIStackView = .init()
    private lazy var dontShowAgainButton: DSLabelButton = .init(config: .init(font: .body1SemiBold, textColor: R.Color.white100, alignment: .center))
    private lazy var closeButton: DSLabelButton = .init(config: .init(font: .body1SemiBold, textColor: R.Color.white100, alignment: .center))

    weak var listener: NFNotificationPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        
        listener?.request(.viewDidLoad)
    }
}

private extension NFNotificationViewController {
    func setupUI() {
        // view
        view.backgroundColor = R.Color.dimmed.withAlphaComponent(0.85)
        
        // containerView
        view.addSubview(containerView)
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = R.Color.gray800
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // imageGuideView
        imageGuideView.contentMode = .scaleAspectFit
        containerView.addSubview(imageGuideView)
        
        // buttonStack
        containerView.addSubview(buttonStack)
        [dontShowAgainButton, closeButton].forEach {
            buttonStack.addArrangedSubview($0)
        }
        
        // dontShowAgainButton
        dontShowAgainButton.update(titleText: "다시보지 않기")
        
        // closeButton
        closeButton.update(titleText: "닫기")
    }
    
    func setupLayout() {
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
            make.bottom.equalTo(view.safeAreaInsets.bottom).inset(20)
            make.height.equalTo(54)
        }
    }
}

extension NFNotificationViewController {
    func request(_ request: NFNotificationPresentableRequest) {
        switch request {
        case let .presentGuideImage(image):
            imageGuideView.image = image
            containerView.setNeedsLayout()
        }
    }
}

#Preview {
    NFNotificationViewController()
}
