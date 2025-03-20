//
//  InputNameInteractor.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import Foundation

import FeatureLogger

import RIBs
import RxSwift

protocol InputNameRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum InputNamePresentableRequest {
    case setName(String)
    case startEdit
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
    case next(OnboardingModel)
}

protocol InputNameListener: AnyObject {
    func request(_ request: InputNameListenerRequest)
}

final class InputNameInteractor: PresentableInteractor<InputNamePresentable>, InputNameInteractable, InputNamePresentableListener {
    // Dependency
    private let logger: Logger

    weak var router: InputNameRouting?
    weak var listener: InputNameListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: InputNamePresentable,
        logger: Logger,
        model: OnboardingModel
    ) {
        self.model = model
        self.logger = logger
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    func reqeust(_ request: InputNamePresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            let log = PageViewLogBuilder(event: .name).build()
            logger.send(log)
            if let name = model.name {
                presenter.request(.setName(name))
            }
            presenter.request(.startEdit)
        case .back:
            listener?.request(.back)
        case let .nameChanged(name):
            model.name = nil
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
            model.name = name
            presenter.request(.updateButtonIsEnabled(true))
        case .goNext:
            let log = PageActionBuilder(event: .nameNext)
                .setProperty(key: "step", value: "이름")
                .build()
            logger.send(log)
            listener?.request(.next(model))
        }
    }
    
    private let helper = InputNameHelper()
    private var model: OnboardingModel
    
    private func validateNameLength(_ name: String) -> Bool {
        return name.count >= 1
    }
    
    private func validateName(_ name: String) -> Bool {
        guard let helper else { return false }
        return helper.isWithinMaxLength(name)
    }
}
