//
//  InputNameViewController.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs
import RxSwift
import UIKit

enum InputNamePresentableListenerRequest {
    case nameChanged(String)
    case goNext
}

protocol InputNamePresentableListener: AnyObject {
    func reqeust(_ request: InputNamePresentableListenerRequest)
}

final class InputNameViewController: UIViewController, InputNamePresentable, InputNameViewControllable {

    weak var listener: InputNamePresentableListener?
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    func request(_ request: InputNamePresentableRequest) {
        switch request {
        case .showNameLengthError:
            mainView.update(.shortNameLength)
        case .showInvalidNameError:
            mainView.update(.invalidName)
        case let .updateButtonIsEnabled(isEnabled):
            mainView.update(.buttonEnabled(isEnabled))
        }
    }
    
    private let mainView = InputNameView()
}

extension InputNameViewController: InputNameViewListener {
    func action(_ action: InputNameView.Action) {
        switch action {
        case let .nameChanged(name):
            listener?.reqeust(.nameChanged(name))
        case .nextButtonTapped:
            listener?.reqeust(.goNext)
        }
    }
}
