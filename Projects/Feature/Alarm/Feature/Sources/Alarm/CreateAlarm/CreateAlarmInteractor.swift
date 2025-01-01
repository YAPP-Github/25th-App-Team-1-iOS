//
//  CreateAlarmInteractor.swift
//  FeatureAlarm
//
//  Created by ever on 12/30/24.
//

import RIBs
import RxSwift

protocol CreateAlarmRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CreateAlarmPresentable: Presentable {
    var listener: CreateAlarmPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

enum CreateAlarmListenerRequest {
    case done(Alarm)
}

protocol CreateAlarmListener: AnyObject {
    func request(_ request: CreateAlarmListenerRequest)
}

final class CreateAlarmInteractor: PresentableInteractor<CreateAlarmPresentable>, CreateAlarmInteractable, CreateAlarmPresentableListener {

    weak var router: CreateAlarmRouting?
    weak var listener: CreateAlarmListener?
    
    override init(presenter: CreateAlarmPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    private var alarm: Alarm = .default
    
    func request(_ request: CreateAlarmPresentableListenerRequest) {
        switch request {
        case .done:
            createAlarm()
        }
    }
    
    private func createAlarm() {
        listener?.request(.done(alarm))
    }
}
