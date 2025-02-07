//
//  EmptyAlarmInteractor.swift
//  FeatureMain
//
//  Created by ever on 2/7/25.
//

import RIBs
import RxSwift

protocol EmptyAlarmRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EmptyAlarmPresentable: Presentable {
    var listener: EmptyAlarmPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol EmptyAlarmListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class EmptyAlarmInteractor: PresentableInteractor<EmptyAlarmPresentable>, EmptyAlarmInteractable, EmptyAlarmPresentableListener {

    weak var router: EmptyAlarmRouting?
    weak var listener: EmptyAlarmListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: EmptyAlarmPresentable) {
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
