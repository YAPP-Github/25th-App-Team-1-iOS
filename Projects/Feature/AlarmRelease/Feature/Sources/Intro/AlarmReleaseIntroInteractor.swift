//
//  AlarmReleaseIntroInteractor.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/10/25.
//

import Foundation

import FeatureCommonDependencies
import FeatureResources
import FeatureAlarmCommon
import FeatureAlarmController
import FeatureLogger
import FeatureNetworking

import RIBs
import RxSwift

public protocol AlarmReleaseIntroRouting: ViewableRouting {}

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
    case releaseAlarm
    case snoozeAlarm
}

public protocol AlarmReleaseIntroListener: AnyObject {
    func request(_ request: AlarmReleaseIntroListenerRequest)
}

final class AlarmReleaseIntroInteractor: PresentableInteractor<AlarmReleaseIntroPresentable>, AlarmReleaseIntroInteractable, AlarmReleaseIntroPresentableListener {
    // Dependency
    private let alarmController: AlarmController
    private let stream: ReleaseAlarmStream
    private let logger: Logger

    weak var router: AlarmReleaseIntroRouting?
    weak var listener: AlarmReleaseIntroListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: AlarmReleaseIntroPresentable,
        alarm: Alarm,
        isFirstAlarm: Bool,
        alarmController: AlarmController,
        stream: ReleaseAlarmStream,
        logger: Logger
    ) {
        self.alarm = alarm
        self.isFirstAlarm = isFirstAlarm
        self.alarmController = alarmController
        self.stream = stream
        self.logger = logger
        remainSnoozeCount = alarm.snoozeOption.count.rawValue
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        bind()
        // 백그라운드 알람 종료
        alarmController.inactivateAlarmWithoutConsecutiveAlarmTask(alarm: alarm)
        
        // 반복 알람이 아닐 경우 상태 비활성화
        if alarm.repeatDays.days.isEmpty {
            var newAlarm = alarm
            newAlarm.isActive = false
            let result = alarmController.updateAlarm(alarm: newAlarm)
            switch result {
            case .success:
                debugPrint("\(Self.self) 단발성 알람 비할성화 성공")
            case .failure(let error):
                debugPrint("\(Self.self) 단발성 알람 비할성화 실패 \(error.localizedDescription)")
            }
        }
        
        // 알람 릴리즈화면 전용 사운드 재생
        playAlarm()
    }
    
    private func bind() {
        stream.snoozeFinished
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self else { return }
                updateSnoozeCount()
                playAlarm()
            }.disposeOnDeactivate(interactor: self)
        
        stream.stopTimer
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self else { return }
                presenter.request(.stopTimer)
            }.disposeOnDeactivate(interactor: self)
    }
    
    func request(_ request: AlarmReleaseIntroPresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            presenter.request(.updateSnooze(alarm.snoozeOption))
        case .snoozeAlarm:
            let log = ExecuteSnoozeLogBuilder(alarmId: alarm.id).build()
            logger.send(log)
            stopAlarm()
            listener?.request(.snoozeAlarm)
        case .releaseAlarm:
            var isFirstAlarmOfDay = true
            if UserDefaults.standard.dailyFirstAlarmIsReleased() {
                // 오늘 해제된 알람이 있는 경우
                isFirstAlarmOfDay = false
                UserDefaults.standard.removeYesterDay()
            } else {
                // 해당 알람이 오늘 첫 알람인 경우
                UserDefaults.standard.setDailyFirstAlarmReleased(isChecked: true)
            }
            let log = DismissAlarmLogBuilder(
                alarmId: alarm.id,
                isFirstAlarm: isFirstAlarmOfDay
            ).build()
            logger.send(log)
            
            stopAlarm()
            listener?.request(.releaseAlarm)
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
        VolumeManager.setVolume(alarm.soundOption.volume)
        AudioPlayerManager.shared.activateSession()
        AudioPlayerManager.shared.playAlarmSound(with: soundUrl, volume: alarm.soundOption.volume, loopCount: -1)
    }
    
    private func stopAlarm() {
        alarmController.inactivateAlarmWithoutConsecutiveAlarmTask(alarm: alarm)
        AudioPlayerManager.shared.stopPlayingSound()
    }
}
