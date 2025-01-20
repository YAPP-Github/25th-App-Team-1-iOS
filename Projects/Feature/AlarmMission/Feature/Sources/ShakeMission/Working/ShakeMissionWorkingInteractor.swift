//
//  ShakeMissionWorkingInteractor.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import RIBs
import RxSwift

protocol ShakeMissionWorkingRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ShakeMissionWorkingPresentable: Presentable {
    var listener: ShakeMissionWorkingPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ShakeMissionWorkingListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ShakeMissionWorkingInteractor: PresentableInteractor<ShakeMissionWorkingPresentable>, ShakeMissionWorkingInteractable, ShakeMissionWorkingPresentableListener {

    weak var router: ShakeMissionWorkingRouting?
    weak var listener: ShakeMissionWorkingListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ShakeMissionWorkingPresentable) {
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
