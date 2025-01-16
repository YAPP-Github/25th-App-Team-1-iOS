//
//  OnboardingFortuneGuideViewController.swift
//  FeatureOnboarding
//
//  Created by ever on 1/15/25.
//

import RIBs
import RxSwift
import UIKit

enum OnboardingFortuneGuidePresentableListenerRequest {
    case start
}

protocol OnboardingFortuneGuidePresentableListener: AnyObject {
    func request(_ request: OnboardingFortuneGuidePresentableListenerRequest)
}

final class OnboardingFortuneGuideViewController: UIViewController, OnboardingFortuneGuidePresentable, OnboardingFortuneGuideViewControllable {

    weak var listener: OnboardingFortuneGuidePresentableListener?
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        mainView.playAnimation()
    }
    
    private let mainView = OnboardingFortuneGuideView()
}

extension OnboardingFortuneGuideViewController: OnboardingFortuneGuideViewListener {
    func action(_ action: OnboardingFortuneGuideView.Action) {
        switch action {
        case .startButtonTapped:
            listener?.request(.start)
        }
    }
}
