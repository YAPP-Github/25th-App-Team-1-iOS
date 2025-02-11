//
//  AlarmReleaseIntroInteractor.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/10/25.
//

import RIBs
import RxSwift

protocol AlarmReleaseIntroRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AlarmReleaseIntroPresentable: Presentable {
    var listener: AlarmReleaseIntroPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AlarmReleaseIntroListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class AlarmReleaseIntroInteractor: PresentableInteractor<AlarmReleaseIntroPresentable>, AlarmReleaseIntroInteractable, AlarmReleaseIntroPresentableListener {

    weak var router: AlarmReleaseIntroRouting?
    weak var listener: AlarmReleaseIntroListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AlarmReleaseIntroPresentable) {
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
