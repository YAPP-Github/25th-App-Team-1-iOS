//
//  MainPageService.swift
//  FeatureMain
//
//  Created by ever on 2/7/25.
//

import UserNotifications
import FeatureUIDependencies
import FeatureCommonDependencies

protocol MainPageServiceable {
    func getAllAlarm() -> [Alarm]
    func addAlarm(_ alarm: Alarm)
    func updateAlarm(_ alarm: Alarm)
    func deleteAlarm(_ alarm: Alarm)
}

struct MainPageService: MainPageServiceable {
    func getAllAlarm() -> [Alarm] {
        AlarmStore.shared.getAll()
    }
    func addAlarm(_ alarm: Alarm) {
        AlarmStore.shared.add(alarm)
        guard let soundUrl = R.AlarmSound.allCases.first(where: { $0.title == alarm.soundOption.selectedSound })?.alarm else { return }
        scheduleNotification(for: alarm)
        scheduleTimer(with: alarm, soundUrl: soundUrl)
    }
    func updateAlarm(_ alarm: Alarm) {
        AlarmStore.shared.update(alarm)
    }
    func deleteAlarm(_ alarm: Alarm) {
        AlarmStore.shared.delete(alarm)
    }
}

extension MainPageService {
    private func scheduleNotification(for alarm: Alarm) {
        let center = UNUserNotificationCenter.current()
        
        // 알림 콘텐츠 구성
        let content = UNMutableNotificationContent()
        content.title = "알람"
        content.body = "설정한 알람 시간입니다."

        // 알림 트리거 구성
        let dateComponents = alarm.nextDateComponents()
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let identifier = alarm.id
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("알림 스케줄링 오류: \(error.localizedDescription)")
            } else {
                print("알림이 성공적으로 스케줄되었습니다. 식별자: \(identifier)")
            }
        }
    }

    func scheduleTimer(with alarm: Alarm, soundUrl: URL) {
        AlarmManager.shared.activateSession()
        let calendar = Calendar.current
        guard let date = calendar.date(from: alarm.nextDateComponents()) else { return }
        let currentDate = Date()
        let timeInterval = date.timeIntervalSince(currentDate)
        print(timeInterval)
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            VolumeManager.setVolume(alarm.soundOption.volume) // 설정한 볼륨값 0.0~1.0으로 설정
            AlarmManager.shared.playAlarmSound(with: soundUrl, volume: alarm.soundOption.volume)
        }

    }
}
