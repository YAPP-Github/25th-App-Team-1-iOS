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
    case back
    case timeChanged(String)
    case iDontKnowButtonTapped
    case next
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
 
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
    
    func request(_ request: InputBornTimePresentableRequest) {
        switch request {
        case .showShortLenghError:
            mainView.update(.shortBornTimeLength)
        case .showInvalidBornTimeError:
            mainView.update(.invalidBornTime)
        case let .updateButton(isEnabled):
            mainView.update(.buttonEnabled(isEnabled))
        }
    }
    
    private let mainView = InputBornTImeView()
}

extension InputBornTimeViewController: InputBornTImeViewListener {
    func action(_ action: InputBornTImeView.Action) {
        switch action {
        case .backButtonTapped:
            listener?.request(.back)
        case let .timeChanged(time):
            listener?.request(.timeChanged(time))
        case .iDontKnowButtonTapped:
            listener?.request(.iDontKnowButtonTapped)
        case .nextButtonTapped:
            listener?.request(.next)
        }
    }
}
