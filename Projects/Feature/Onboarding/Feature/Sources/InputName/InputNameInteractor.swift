//
//  InputNameInteractor.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import Foundation
import RIBs
import RxSwift

protocol InputNameRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum InputNamePresentableRequest {
    case showNameLengthError
    case showInvalidNameError
    case updateButtonIsEnabled(Bool)
}
protocol InputNamePresentable: Presentable {
    var listener: InputNamePresentableListener? { get set }
    func request(_ request: InputNamePresentableRequest)
}

enum InputNameListenerRequest {
    case back
    case next(String)
}

protocol InputNameListener: AnyObject {
    func request(_ request: InputNameListenerRequest)
}

final class InputNameInteractor: PresentableInteractor<InputNamePresentable>, InputNameInteractable, InputNamePresentableListener {

    weak var router: InputNameRouting?
    weak var listener: InputNameListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: InputNamePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    func reqeust(_ request: InputNamePresentableListenerRequest) {
        switch request {
        case .back:
            listener?.request(.back)
        case let .nameChanged(name):
            self.name = name
            guard validateNameLength(name) else {
                presenter.request(.showNameLengthError)
                presenter.request(.updateButtonIsEnabled(false))
                return
            }
            
            guard validateName(name) else {
                presenter.request(.showInvalidNameError)
                presenter.request(.updateButtonIsEnabled(false))
                return
            }
            presenter.request(.updateButtonIsEnabled(true))
        case .goNext:
            listener?.request(.next(name))
        }
    }
    
    private let helper = InputNameHelper()
    private var name: String = ""
    
    private func validateNameLength(_ name: String) -> Bool {
        return name.count >= 1
    }
    
    private func validateName(_ name: String) -> Bool {
        guard let helper else { return false }
        return helper.isWithinMaxLength(name)
    }
}
