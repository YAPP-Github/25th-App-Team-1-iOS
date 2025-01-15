//
//  InputSummaryInteractor.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/15/25.
//

import RIBs
import RxSwift

protocol InputSummaryRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol InputSummaryPresentable: Presentable {
    var listener: InputSummaryPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol InputSummaryListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class InputSummaryInteractor: PresentableInteractor<InputSummaryPresentable>, InputSummaryInteractable, InputSummaryPresentableListener {

    weak var router: InputSummaryRouting?
    weak var listener: InputSummaryListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: InputSummaryPresentable) {
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
