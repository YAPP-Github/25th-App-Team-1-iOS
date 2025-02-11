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

enum AlarmReleaseIntroPresentableRequest {
    case updateSnooze(SnoozeOption)
    case updateSnoozeCount(Int)
    case hideSnoozeButton
}

protocol AlarmReleaseIntroPresentable: Presentable {
    var listener: AlarmReleaseIntroPresentableListener? { get set }
    func request(_ request: AlarmReleaseIntroPresentableRequest)
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
        remainSnoozeCount = alarm.snoozeOption.count.rawValue
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    func request(_ request: AlarmReleaseIntroPresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            presenter.request(.updateSnooze(alarm.snoozeOption))
        case .snoozeAlarm:
            updateSnoozeCount()
        case .releaseAlarm:
            listener?.request(.releaseAlarm)
        }
    }
    
    private let alarm: Alarm
    private var remainSnoozeCount: Int?
    
    private func updateSnoozeCount() {
        guard alarm.snoozeOption.count != .unlimited,
        let currentRemainCount = remainSnoozeCount else { return }
        let newCount = currentRemainCount - 1
        
        self.remainSnoozeCount = newCount
        
        if newCount > 0 {
            presenter.request(.updateSnoozeCount(newCount))
        } else {
            presenter.request(.hideSnoozeButton)
        }
    }
}
