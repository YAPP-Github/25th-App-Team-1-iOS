//
//  OnboardingIntroViewController.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs
import RxSwift
import UIKit

enum OnboardingIntroPresentableListenerRequest {
    case viewDidLoad
    case next
}

protocol OnboardingIntroPresentableListener: AnyObject {
    func request(_ request: OnboardingIntroPresentableListenerRequest)
}

final class OnboardingIntroViewController: UIViewController, OnboardingIntroPresentable, OnboardingIntroViewControllable {

    weak var listener: OnboardingIntroPresentableListener?
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        listener?.request(.viewDidLoad)
    }
    
    private let mainView = OnboardingIntroView()
}

extension OnboardingIntroViewController: OnboardingIntroViewListener {
    func action(_ action: OnboardingIntroView.Action) {
        switch action {
        case .nextButtonTapped:
            listener?.request(.next)
        }
    }
}
