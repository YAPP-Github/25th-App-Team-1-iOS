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
        scheduleNotification(for: alarm, soundUrl: soundUrl)
    }
    func updateAlarm(_ alarm: Alarm) {
        AlarmStore.shared.update(alarm)
        removeScheduledNotification(alarm: alarm)
        if alarm.isActive,
           let soundUrl = R.AlarmSound.allCases.first(where: { $0.title == alarm.soundOption.selectedSound })?.alarm {
            scheduleNotification(for: alarm, soundUrl: soundUrl)
        }
    }
    func deleteAlarm(_ alarm: Alarm) {
        AlarmStore.shared.delete(alarm)
    }
}

extension MainPageService {
    private func scheduleNotification(for alarm: Alarm, soundUrl: URL) {
        let center = UNUserNotificationCenter.current()
        
        let sound = copySoundFileToLibrary(with: soundUrl) ?? .default
        
        let alarmComponentsList = alarm.nextDateComponents()
        
        for components in alarmComponentsList {
            // 첫 알람 생성
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            
            let content = UNMutableNotificationContent()
            content.title = "오르비 알람"
            content.body = "알람을 해제할 시간이에요!"
            content.userInfo = ["alarmId": alarm.id]
            content.sound = sound
            
            let identifier = "\(alarm.id)_\(components.weekday ?? 0)_\(components.day ?? 0)_\(0)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("알림 스케줄링 오류 (\(identifier)): \(error.localizedDescription)")
                } else {
                    print("알림 예약 성공: \(identifier)")
                    print(request)
                }
            }
            generateRepeatedAlarm(for: alarm, sound: sound, components: components)
        }
        
    }
    
    private func generateRepeatedAlarm(for alarm: Alarm, sound: UNNotificationSound, components: DateComponents) {
        guard let alarmDate = Calendar.current.date(from: components) else { return }
        let now = Date()
        let center = UNUserNotificationCenter.current()
        
        let initialDelay = alarmDate.timeIntervalSince(now)
        
        if initialDelay < 5 {
            return
        }
        
        for i in 1..<20 {
            let content = UNMutableNotificationContent()
            content.title = "오르비 알람"
            content.body = "알람을 해제할 시간이에요!"
            content.userInfo = ["alarmId": alarm.id]
            content.sound = sound
            let delay = initialDelay + Double(i * 5)
            if i % 6 == 0 {
                content.sound = sound
            } else {
                content.sound = nil
            }
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
            let identifier = "\(alarm.id)_\(components.weekday ?? 0)_\(components.day ?? 0)_\(i)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("알림 스케줄링 오류 (\(identifier)): \(error.localizedDescription)")
                } else {
                    print("알림 예약 성공: \(identifier)")
                    print(request)
                }
            }
            
        }
    }
    
    @discardableResult
    func copySoundFileToLibrary(with soundUrl: URL) -> UNNotificationSound? {
        let fileManager = FileManager.default
        
        // Library/Sounds 디렉토리 경로
        guard let libraryURL = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            print("Library 디렉토리를 찾을 수 없습니다.")
            return nil
        }
        let soundsURL = libraryURL.appendingPathComponent("Sounds")
        
        // Library/Sounds 디렉토리가 없으면 생성
        if !fileManager.fileExists(atPath: soundsURL.path) {
            do {
                try fileManager.createDirectory(at: soundsURL, withIntermediateDirectories: true, attributes: nil)
                print("Library/Sounds 디렉토리를 생성했습니다.")
            } catch {
                print("Library/Sounds 디렉토리 생성 실패: \(error)")
                return nil
            }
        }
        
        // 목적지 파일 URL
        let destinationURL = soundsURL.appendingPathComponent(soundUrl.lastPathComponent)
        
        // 이미 파일이 존재하는지 확인
        if !fileManager.fileExists(atPath: destinationURL.path) {
            do {
                try fileManager.copyItem(at: soundUrl, to: destinationURL)
                print("사운드 파일을 Library/Sounds로 복사했습니다: \(destinationURL.path)")
                return UNNotificationSound(named: UNNotificationSoundName(destinationURL.lastPathComponent))
            } catch {
                print("사운드 파일 복사 실패: \(error)")
                return nil
            }
        } else {
            print("사운드 파일이 이미 Library/Sounds에 존재합니다.")
            print(destinationURL)
        }
        
        return UNNotificationSound(named: UNNotificationSoundName(destinationURL.lastPathComponent))
    }
    
    func removeScheduledNotification(alarm: Alarm) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            let identifiersToRemove = requests.compactMap { request -> String? in
                // 우리가 예약할 때 "\(alarm.id)_\(i)" 형태로 식별자를 생성했으므로,
                // alarmId가 포함된 식별자를 제거하도록 함
                if request.identifier.hasPrefix("\(alarm.id)_"){
                    return request.identifier
                }
                return nil
            }
            
            // 필터링된 식별자들의 알림 제거
            center.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
            print("삭제된 알림 식별자들: \(identifiersToRemove)")
        }
    }
}
