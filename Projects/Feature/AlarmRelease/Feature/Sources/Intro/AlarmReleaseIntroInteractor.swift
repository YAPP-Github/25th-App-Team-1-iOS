//
//  AlarmReleaseIntroInteractor.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/10/25.
//

import RIBs
import RxSwift
import FeatureCommonDependencies
import FeatureResources
import FeatureAlarmCommon

public enum AlarmReleaseIntroRouterRequest {
    case routeToSnooze(SnoozeOption)
    case detachSnooze
}

public protocol AlarmReleaseIntroRouting: ViewableRouting {
    func request(_ request: AlarmReleaseIntroRouterRequest)
}

enum AlarmReleaseIntroPresentableRequest {
    case updateSnooze(SnoozeOption)
    case updateSnoozeCount(Int)
    case hideSnoozeButton
    case stopTimer
}

protocol AlarmReleaseIntroPresentable: Presentable {
    var listener: AlarmReleaseIntroPresentableListener? { get set }
    func request(_ request: AlarmReleaseIntroPresentableRequest)
}

public enum AlarmReleaseIntroListenerRequest {
    case releaseAlarm(Bool)
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
        alarm: Alarm,
        isFirstAlarm: Bool
    ) {
        self.alarm = alarm
        self.isFirstAlarm = isFirstAlarm
        remainSnoozeCount = alarm.snoozeOption.count.rawValue
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        playAlarm()
    }
    
    func request(_ request: AlarmReleaseIntroPresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            presenter.request(.updateSnooze(alarm.snoozeOption))
        case .snoozeAlarm:
            stopAlarm()
            router?.request(.routeToSnooze(alarm.snoozeOption))
        case .releaseAlarm:
            stopAlarm()
            listener?.request(.releaseAlarm(isFirstAlarm))
        }
    }
    
    private let alarm: Alarm
    private let isFirstAlarm: Bool
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
    
    private func playAlarm() {
        guard let soundUrl = R.AlarmSound.allCases.first(where: { $0.title == alarm.soundOption.selectedSound })?.alarm else { return }
        AudioPlayerManager.shared.activateSession()
        VolumeManager.setVolume(alarm.soundOption.volume)
        AudioPlayerManager.shared.playAlarmSound(with: soundUrl, volume: alarm.soundOption.volume, loopCount: -1)
    }
    
    private func stopAlarm() {
        AudioPlayerManager.shared.stopPlayingSound()
    }
}

extension AlarmReleaseIntroInteractor {
    func request(_ request: AlarmReleaseSnoozeListenerRequest) {
        router?.request(.detachSnooze)
        switch request {
        case .releaseAlarm:
            presenter.request(.stopTimer)
            stopAlarm()
            listener?.request(.releaseAlarm(isFirstAlarm))
        case .snoozeFinished:
            updateSnoozeCount()
            playAlarm()
        }
    }
}
