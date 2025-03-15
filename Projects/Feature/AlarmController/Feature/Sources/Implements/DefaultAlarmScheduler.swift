//
//  DefaultAlarmScheduler.swift
//  FeatureAlarmController
//
//  Created by choijunios on 3/8/25.
//

import UIKit

import FeatureResources
import FeatureCommonDependencies
import MediaPlayer

enum AlarmNotificationConfig {
    static let defaultTitle: String = "오르비 알람"
    static let defaultMessage: String = "알람을 해제할 시간이에요!"
}

public final class DefaultAlarmScheduler: AlarmScheduler {
    // Dependency
    private let backgoundTaskScheduler: BackgoundTaskScheduler
    private let alarmAudioController: AlarmAudioController
    private let vibrationManager: VibrationManager
    
    
    // State
    private let notificationLimit = 20
    
    
    // Helper
    private let jsonEncoder = JSONEncoder()
    
    
    public init(
        backgoundTaskScheduler: BackgoundTaskScheduler,
        alarmAudioController: AlarmAudioController,
        vibrationManager: VibrationManager
    ) {
        self.backgoundTaskScheduler = backgoundTaskScheduler
        self.alarmAudioController = alarmAudioController
        self.vibrationManager = vibrationManager
    }
    
    private func schedule(date: Date, job: @escaping () -> Void) {
        let interval = Calendar.current.dateComponents([.second], from: .now, to: date).second!
        let dispatchWallTime = DispatchWallTime.now() + .seconds(interval)
        DispatchQueue.global().asyncAfter(wallDeadline: dispatchWallTime) { job() }
    }
    
    private func registerNotification(
        id: String,
        date: Date,
        title: String,
        message: String,
        userInfo: [String: Any]
    ) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = message
        notificationContent.userInfo = userInfo
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: id,
            content: notificationContent,
            trigger: trigger
        )
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request)
    }
}


// MARK: AlarmScheduler
public extension DefaultAlarmScheduler {
    func schedule(contents: [AlarmScheduleContent], alarm: Alarm) {
        guard let components = alarm.earliestDateComponent(),
              let alarmDate = Calendar.current.date(from: components) else { return }
        contents.forEach { content in
            switch content {
            case .initialLocalNotification:
                
                // MARK: 최초 로컬노티피케이션 등록
                
                var notificationUserinfo: [String: Any] = [:]
                if let encoded = try? jsonEncoder.encode(alarm) {
                    notificationUserinfo["alarm"] = encoded
                }
                let notificationId = KeyGenerator.notification(alarmId: alarm.id)
                registerNotification(
                    id: notificationId,
                    date: alarmDate,
                    title: AlarmNotificationConfig.defaultTitle,
                    message: AlarmNotificationConfig.defaultMessage,
                    userInfo: notificationUserinfo
                )
            case .registerLocalNotificationRepeatedly:
                
                // MARK: 로컬 노티피케이션 반복등록 작업 등록
                
                var notificationUserinfo: [String: Any] = [:]
                if let encoded = try? jsonEncoder.encode(alarm) {
                    notificationUserinfo["alarm"] = encoded
                }
                backgoundTaskScheduler.register(
                    id: KeyGenerator.backgroundTask(content: content.contentKey, alarmId: alarm.id),
                    startDate: alarmDate,
                    type: .repeats(intervalSeconds: 4, count: .limit(count: notificationLimit))) { [weak self] _ in
                        guard let self else { return }
                        let calendar = Calendar.current
                        let notificationDate = calendar.date(byAdding: .second, value: 4, to: .now)!
                        let notificationId = KeyGenerator.notification(alarmId: alarm.id)
                        registerNotification(
                            id: notificationId,
                            date: notificationDate,
                            title: AlarmNotificationConfig.defaultTitle,
                            message: AlarmNotificationConfig.defaultMessage,
                            userInfo: notificationUserinfo
                        )
                    }
            case .registerConsecutiveAlarm:
                
                // MARK: 반복되는 알람등록 작업 등록
                
                if !alarm.repeatDays.days.isEmpty {
                    backgoundTaskScheduler.register(
                        id: KeyGenerator.backgroundTask(content: content.contentKey, alarmId: alarm.id),
                        startDate: alarmDate,
                        type: .once,
                        task: { [weak self] _ in
                            guard let self else { return }
                            var newAlarm = alarm
                            let originAlarmId = alarm.id
                            if AlarmKeyGenerator.isRoot(id: originAlarmId) {
                                // 이전 알람이 루트 알람인 경우
                                newAlarm.id = AlarmKeyGenerator.createChildKey(base: originAlarmId)
                            } else {
                                // 이전 알람이 루트가 아닌 경우
                                let root = AlarmKeyGenerator.getRoot(id: originAlarmId)
                                newAlarm.id = AlarmKeyGenerator.createChildKey(base: root)
                            }
                            schedule(contents: contents, alarm: newAlarm)
                        })
                }
            case .audio:
                
                // MARK: 알람 소리재생 작업 등록
                
                backgoundTaskScheduler.register(
                    id: KeyGenerator.backgroundTask(content: content.contentKey, alarmId: alarm.id),
                    startDate: alarmDate,
                    type: .once,
                    task: { [weak self] _ in
                        guard let self else { return }
                        // 알람 사운드 재생
                        let soundOption = alarm.soundOption
                        if soundOption.isSoundOn, let audioURL = alarm.selectedSoundUrl {
                            // 사운드 재생 전 시스템 볼륨 알람에서 설정한 볼륨으로 변경
                            VolumeManager.setVolume(soundOption.volume)
                            alarmAudioController.play(
                                id: KeyGenerator.audioTask(alarmId: alarm.id),
                                audioURL: audioURL,
                                volume: soundOption.volume
                            )
                        }
                    })

            case .vibration:
                
                // MARK: 진동발생 작업 등록
                
                if alarm.soundOption.isVibrationOn {
                    backgoundTaskScheduler.register(
                        id: KeyGenerator.backgroundTask(content: content.contentKey, alarmId: alarm.id),
                        startDate: alarmDate,
                        type: .repeats(intervalSeconds: 1, count: .limit(count: 30)),
                        task: { [weak self] _ in
                            guard let self else { return }
                            vibrationManager.vibarate()
                        })
                }
            }
        }
    }

    func inactivateSchedule(matchingType: IdMatchingType, contents: [AlarmScheduleContent], alarm: Alarm) {
        var backgroundTaskIdentifiers: [String] = []
        contents.forEach { content in
            switch content {
            case .initialLocalNotification:
                let notiCenter = UNUserNotificationCenter.current()
                let notificationId = KeyGenerator.notification(alarmId: alarm.id)
                switch matchingType {
                case .exact:
                    notiCenter.removePendingNotificationRequests(withIdentifiers: [notificationId])
                case .contains:
                    notiCenter.getPendingNotificationRequests { requests in
                        let identifiers = requests
                            .map(\.identifier)
                            .filter({ $0.contains(notificationId) })
                        notiCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
                    }
                }
            case .audio:
                // 재생중이던 오디오 정지 및 삭제
                alarmAudioController.stopAndRemove(
                    matchingType: matchingType,
                    id: KeyGenerator.audioTask(alarmId: alarm.id)
                )
                backgroundTaskIdentifiers.append(KeyGenerator.backgroundTask(
                    content: content.contentKey,
                    alarmId: alarm.id
                ))
            case .registerLocalNotificationRepeatedly, .registerConsecutiveAlarm, .vibration:
                backgroundTaskIdentifiers.append(KeyGenerator.backgroundTask(
                    content: content.contentKey,
                    alarmId: alarm.id
                ))
            }
        }
        backgoundTaskScheduler.cancelTasks(
            matchType: matchingType,
            identifiers: backgroundTaskIdentifiers
        )
    }
}
