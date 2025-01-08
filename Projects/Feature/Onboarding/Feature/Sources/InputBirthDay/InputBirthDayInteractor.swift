//
//  InputBirthDayInteractor.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import RIBs
import RxSwift

protocol InputBirthDayRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol InputBirthDayPresentable: Presentable {
    var listener: InputBirthDayPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol InputBirthDayListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class InputBirthDayInteractor: PresentableInteractor<InputBirthDayPresentable>, InputBirthDayInteractable, InputBirthDayPresentableListener {

    weak var router: InputBirthDayRouting?
    weak var listener: InputBirthDayListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: InputBirthDayPresentable) {
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
