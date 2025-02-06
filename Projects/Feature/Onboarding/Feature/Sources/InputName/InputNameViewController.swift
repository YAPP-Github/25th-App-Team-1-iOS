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
    case viewDidLoad
    case back
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        listener?.reqeust(.viewDidLoad)
    }
    
    func request(_ request: InputNamePresentableRequest) {
        switch request {
        case let .setName(name):
            mainView.update(.setName(name))
            mainView.update(.buttonEnabled(true))
        case .startEdit:
            mainView.update(.startEdit)
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
        case .backButtonTapped:
            listener?.reqeust(.back)
        case let .nameChanged(name):
            listener?.reqeust(.nameChanged(name))
        case .nextButtonTapped:
            listener?.reqeust(.goNext)
        }
    }
}
