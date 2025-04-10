//
//  InputBirthDateInteractor.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import FeatureCommonDependencies
import FeatureLogger

import RIBs
import RxSwift

protocol InputBirthDateRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum InputBirthDatePresentableRequest {
    case setBirthDate(BirthDateData)
}

protocol InputBirthDatePresentable: Presentable {
    var listener: InputBirthDatePresentableListener? { get set }
    func request(_ request: InputBirthDatePresentableRequest)
}

enum InputBirthDateListenerRequest {
    case back
    case confirmBirthDate(OnboardingModel)
}

protocol InputBirthDateListener: AnyObject {
    func request(_ request: InputBirthDateListenerRequest)
}

final class InputBirthDateInteractor: PresentableInteractor<InputBirthDatePresentable>, InputBirthDateInteractable, InputBirthDatePresentableListener {
    // Dependency
    private let logger: Logger

    weak var router: InputBirthDateRouting?
    weak var listener: InputBirthDateListener?
    
    // State
    private(set) var birthDate: BirthDateData?
    

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: InputBirthDatePresentable,
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


// MARK: InputBirthDatePresentableListener
extension InputBirthDateInteractor {
    
    func request(_ request: InputBirthDatePresenterRequest) {
        switch request {
        case .viewDidLoad:
            let log = PageViewLogBuilder(event: .birthDate).build()
            logger.send(log)
            presenter.request(.setBirthDate(model.birthDate))
        case .exitPage:
            listener?.request(.back)
        case .confirmUserInputAndExit:
            let log = PageActionBuilder(event: .birthTimeNext)
                .setProperty(key: "step", value: "생년월일")
                .build()
            logger.send(log)
            listener?.request(.confirmBirthDate(model))
        case let .updateCurrentBirthDate(birthDateData):
            model.birthDate = birthDateData
        }
    }
}
