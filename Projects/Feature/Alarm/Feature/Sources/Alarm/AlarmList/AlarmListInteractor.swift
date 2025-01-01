//
//  AlarmListInteractor.swift
//  FeatureAlarmExample
//
//  Created by ever on 12/29/24.
//

import RIBs
import RxSwift

protocol AlarmListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AlarmListPresentable: Presentable {
    var listener: AlarmListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

enum AlarmListListenerRequest {
    case addAlarm
}

protocol AlarmListListener: AnyObject {
    func request(_ request: AlarmListListenerRequest)
}

final class AlarmListInteractor: PresentableInteractor<AlarmListPresentable>, AlarmListInteractable, AlarmListPresentableListener {

    weak var router: AlarmListRouting?
    weak var listener: AlarmListListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AlarmListPresentable) {
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
    
    func request(_ request: AlarmListPresentableListenerRequest) {
        switch request {
        case .addAlarm:
            listener?.request(.addAlarm)
        }
    }
}
