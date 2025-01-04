//
//  InputBornTimeViewController.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs
import RxSwift
import UIKit

enum InputBornTimePresentableListenerRequest {
    case timeChanged(String)
    case iDontKnowButtonTapped
}

protocol InputBornTimePresentableListener: AnyObject {
    func request(_ request: InputBornTimePresentableListenerRequest)
}

final class InputBornTimeViewController: UIViewController, InputBornTimePresentable, InputBornTimeViewControllable {

    weak var listener: InputBornTimePresentableListener?
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    private let mainView = InputBornTImeView()
}

extension InputBornTimeViewController: InputBornTImeViewListener {
    func action(_ action: InputBornTImeView.Action) {
        switch action {
        case let .timeChanged(time):
            listener?.request(.timeChanged(time))
        case .iDontKnowButtonTapped:
            listener?.request(.iDontKnowButtonTapped)
        }
    }
}
