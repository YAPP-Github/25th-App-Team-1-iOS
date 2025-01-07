//
//  InputGenderInteractor.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/7/25.
//

import RIBs
import RxSwift

protocol InputGenderRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol InputGenderPresentable: Presentable {
    var listener: InputGenderPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol InputGenderListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class InputGenderInteractor: PresentableInteractor<InputGenderPresentable>, InputGenderInteractable, InputGenderPresentableListener {

    weak var router: InputGenderRouting?
    weak var listener: InputGenderListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: InputGenderPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
