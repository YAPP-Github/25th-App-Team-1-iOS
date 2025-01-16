//
//  OnboardingMissionGuideViewController.swift
//  FeatureOnboarding
//
//  Created by ever on 1/15/25.
//

import RIBs
import RxSwift
import UIKit

enum OnboardingMissionGuidePresentableListenerRequest {
    case next
}

protocol OnboardingMissionGuidePresentableListener: AnyObject {
    func request(_ request: OnboardingMissionGuidePresentableListenerRequest)
}

final class OnboardingMissionGuideViewController: UIViewController, OnboardingMissionGuidePresentable, OnboardingMissionGuideViewControllable {

    weak var listener: OnboardingMissionGuidePresentableListener?
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        mainView.playAnimation()
    }
    
    private let mainView = OnboardingMissionGuideView()
}

extension OnboardingMissionGuideViewController: OnboardingMissionGuideViewListener {
    func action(_ action: OnboardingMissionGuideView.Action) {
        switch action {
        case .nextButtonTapped:
            listener?.request(.next)
        }
    }
}
