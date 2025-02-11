//
//  AlarmReleaseIntroInteractor.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/10/25.
//

import RIBs
import RxSwift
import FeatureCommonDependencies

public protocol AlarmReleaseIntroRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AlarmReleaseIntroPresentable: Presentable {
    var listener: AlarmReleaseIntroPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public enum AlarmReleaseIntroListenerRequest {
    case releaseAlarm
}

public protocol AlarmReleaseIntroListener: AnyObject {
    func request(_ request: AlarmReleaseIntroListenerRequest)
}

final class AlarmReleaseIntroInteractor: PresentableInteractor<AlarmReleaseIntroPresentable>, AlarmReleaseIntroInteractable, AlarmReleaseIntroPresentableListener {

    weak var router: AlarmReleaseIntroRouting?
    weak var listener: AlarmReleaseIntroListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: AlarmReleaseIntroPresentable,
        alarm: Alarm
    ) {
        self.alarm = alarm
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    private let alarm: Alarm
    
    func request(_ request: AlarmReleaseIntroPresentableListenerRequest) {
        switch request {
        case .snoozeAlarm:
            print("SnoozeAlarmTapped")
        case .releaseAlarm:
            listener?.request(.releaseAlarm)
        }
    }
}
