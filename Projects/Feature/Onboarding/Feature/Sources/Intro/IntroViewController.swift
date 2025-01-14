//
//  IntroViewController.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs
import RxSwift
import UIKit

enum IntroPresentableListenerRequest {
    case next
}

protocol IntroPresentableListener: AnyObject {
    func request(_ request: IntroPresentableListenerRequest)
}

final class IntroViewController: UIViewController, IntroPresentable, IntroViewControllable {

    weak var listener: IntroPresentableListener?
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.playAnimation()
        navigationController?.isNavigationBarHidden = true
    }
    
    private let mainView = OnboardingIntroView()
}

extension IntroViewController: OnboardingIntroViewListener {
    func action(_ action: OnboardingIntroView.Action) {
        switch action {
        case .nextButtonTapped:
            listener?.request(.next)
        }
    }
}
