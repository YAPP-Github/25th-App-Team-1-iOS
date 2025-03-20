//
//  InputGenderInteractor.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/7/25.
//

import FeatureCommonDependencies
import FeatureLogger

import RIBs
import RxSwift

protocol InputGenderRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum InputGenderInteractorAction {
    case setGender(Gender)
    case updateButtonState(isEnabled: Bool)
}

protocol InputGenderPresentable: Presentable {
    var listener: InputGenderPresentableListener? { get set }

    func action(_ action: InputGenderInteractorAction)
}

enum InputGenderListenerRequest {
    case back
    case next(OnboardingModel)
}

protocol InputGenderListener: AnyObject {
    func request(_ request: InputGenderListenerRequest)
}

final class InputGenderInteractor: PresentableInteractor<InputGenderPresentable>, InputGenderInteractable, InputGenderPresentableListener {
    // Dependency
    private let logger: Logger

    weak var router: InputGenderRouting?
    weak var listener: InputGenderListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: InputGenderPresentable,
        logger: Logger,
        model: OnboardingModel
    ) {
        self.logger = logger
        self.model = model
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    private var model: OnboardingModel
}

// MARK: InputGenderPresentableListener
extension InputGenderInteractor {
    
    func request(_ request: InputGenderPresenterRequest) {
        
        switch request {
        case .viewDidLoad:
            let log = PageViewLogBuilder(event: .gender).build()
            logger.send(log)
            if let gender = model.gender {
                presenter.action(.setGender(gender))
                presenter.action(.updateButtonState(isEnabled: true))
            } else {
                presenter.action(.updateButtonState(isEnabled: false))
            }
            
        case .updateSelectedGender(let gender):
            model.gender = gender
            
            let buttonIsEnabled = (gender != nil)
            presenter.action(.updateButtonState(isEnabled: buttonIsEnabled))
            
        case .confirmCurrentGender:
            guard let gender = model.gender else { return }
            let log = PageActionBuilder(event: .genderSelect)
                .setProperty(key: "gender", value: {
                    switch gender {
                    case .male:
                        "남자"
                    case .female:
                        "여자"
                    }
                }())
                .build()
            logger.send(log)
            listener?.request(.next(model))
        case .exitPage:
            listener?.request(.back)
        }
    }
}
