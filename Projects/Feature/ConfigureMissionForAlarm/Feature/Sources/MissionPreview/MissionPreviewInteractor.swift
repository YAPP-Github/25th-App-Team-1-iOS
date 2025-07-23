//
//  MissionPreviewInteractor.swift
//  FeatureConfigureMissionForAlarm
//
//  Created by choijunios on 7/23/25.
//

import RIBs
import RxSwift

protocol MissionPreviewRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MissionPreviewPresentable: Presentable {
    var listener: MissionPreviewPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MissionPreviewListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MissionPreviewInteractor: PresentableInteractor<MissionPreviewPresentable>, MissionPreviewInteractable, MissionPreviewPresentableListener {

    weak var router: MissionPreviewRouting?
    weak var listener: MissionPreviewListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: MissionPreviewPresentable) {
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
