//
//  DefaultAlarmScheduler.swift
//  FeatureAlarmController
//
//  Created by choijunios on 3/8/25.
//

import UIKit

import FeatureCommonEntity

public final class DefaultAlarmScheduler: AlarmScheduler {
    // Dependency
    private let backgoundTaskScheduler: BackgoundTaskScheduler
    private let alarmAudioController: AlarmAudioController
    private let vibrationManager: VibrationManager
    
    
    // State
    private let notificationLimit = 20
    
    
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
    
    private func registerNotification(id: String, date: Date, alarm: Alarm?) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "일어나세요"
        notificationContent.body = "일어나시라고요~!"
        if let alarm, let encoded = try? JSONEncoder().encode(alarm) {
            notificationContent.userInfo["alarm"] = encoded
        }
        
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
    func schedule(alarm: Alarm) {
        guard let components = alarm.earliestDateComponent(),
              let alarmDate = Calendar.current.date(from: components) else { return }
        
        // 사운드 재생, 후속 알람등록 백그라운드 테스크
        backgoundTaskScheduler.register(
            id: KeyGenerator.backgroundTask(type: .soundAndRepeatDays, alarmId: alarm.id),
            startDate: alarmDate,
            type: .once,
            task: { [weak self] _ in
                guard let self else { return }
                
                // MARK: Test sound
                let audioPath = Bundle(for: Self.self).path(forResource: "test", ofType: "caf")!
                
                // 알람 사운드 재생
                let soundOption = alarm.soundOption
                if soundOption.isSoundOn {
                    alarmAudioController.play(
                        id: KeyGenerator.audioTask(alarmId: alarm.id),
                        audioURL: .init(string: audioPath)!,
                        volume: soundOption.volume
                    )
                }
                
                // 반복요일이 지정되어 있는 경우 후속 알람 등록
                if !alarm.repeatDays.days.isEmpty {
                    schedule(alarm: alarm)
                }
            })
        
        // 진동
        if alarm.soundOption.isVibrationOn {
            backgoundTaskScheduler.register(
                id: KeyGenerator.backgroundTask(type: .vibration, alarmId: alarm.id),
                startDate: alarmDate,
                type: .repeats(intervalSeconds: 1, count: .limit(count: 30)),
                task: { [weak self] _ in
                    guard let self else { return }
                    vibrationManager.vibarate()
                })
        }
        
        
        // 로컬 노티피케이션
        let notificationId = KeyGenerator.notification(alarmId: alarm.id)
        registerNotification(
            id: notificationId,
            date: alarmDate,
            alarm: alarm
        )
        backgoundTaskScheduler.register(
            id: KeyGenerator.backgroundTask(type: .notification, alarmId: alarm.id),
            startDate: alarmDate,
            type: .repeats(intervalSeconds: 4, count: .limit(count: notificationLimit))) { [weak self] index in
                guard let self else { return }
                let calendar = Calendar.current
                let notificationDate = calendar.date(byAdding: .second, value: 4, to: .now)!
                registerNotification(
                    id: notificationId+String(index),
                    date: notificationDate,
                    alarm: alarm
                )
            }
    }
    
    func unschedule(alarm: Alarm) {
        // #1. 로컬 노티피케이션 취소
        let notiCenter = UNUserNotificationCenter.current()
        let notificationId = KeyGenerator.notification(alarmId: alarm.id)
        notiCenter.getPendingNotificationRequests { requests in
            let identifiers = requests
                .filter({ $0.identifier.contains(notificationId) })
                .map({ $0.identifier })
            notiCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        
        // #2. 백그라운드 작업
        let backgroundTaskIdentifiers = AlarmBackgoundTaskType.allCases.map { type in
            KeyGenerator.backgroundTask(type: type, alarmId: alarm.id)
        }
        backgoundTaskScheduler.cancelTasks(identifiers: backgroundTaskIdentifiers)
        
        // #3. 사운드 작업
        alarmAudioController.stopAndRemove(
            id: KeyGenerator.audioTask(alarmId: alarm.id)
        )
    }
}
