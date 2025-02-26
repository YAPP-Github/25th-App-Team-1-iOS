//
//  AlarmScheduler.swift
//  FeatureAlarmCommon
//
//  Created by ever on 2/26/25.
//

import Foundation
import FeatureCommonDependencies
import FeatureResources
import UserNotifications

public struct AlarmScheduler {
    public static let shared = AlarmScheduler()
    
    private init() {}
    
    public func addAlarm(_ alarm: Alarm) {
        // UserDefault에 알람 추가
        AlarmStore.shared.add(alarm)
        // 알람 스케쥴링
        guard let soundUrl = alarm.selectedSoundUrl else { return }
        scheduleNotification(for: alarm, soundUrl: soundUrl)
    }
    
    public func updateAlarm(_ alarm: Alarm) {
        AlarmStore.shared.update(alarm)
        // 기존 설정된 알람 제거
        removeScheduledNotification(alarm: alarm)
        // 알람 켜져있을 경우에만 알람 설정하도록 함.
        guard alarm.isActive, let soundUrl = alarm.selectedSoundUrl else { return }
        
        scheduleNotification(for: alarm, soundUrl: soundUrl)
    }
    
    public func deleteAlarm(_ alarm: Alarm) {
        AlarmStore.shared.delete(alarm)
        removeScheduledNotification(alarm: alarm)
    }
    
    private func scheduleNotification(for alarm: Alarm, soundUrl: URL) {
        guard let components = alarm.earliestDateComponent(),
              let alarmDate = Calendar.current.date(from: components) else { return }
        
        let initialDelay = alarmDate.timeIntervalSinceNow
        
        let center = UNUserNotificationCenter.current()
        let sound = copySoundFileToLibrary(with: soundUrl) ?? .default
        
        let content = UNMutableNotificationContent()
        content.title = "오르비 알람"
        content.body = "알람을 해제할 시간이에요!"
        content.userInfo = ["alarmId": alarm.id]
        
        let semaphore = DispatchSemaphore(value: 0)
        
        for i in 0..<20 {
            let delay = initialDelay + Double(i * 5)
            if i % 30 == 0 {
                content.sound = sound
            } else {
                content.sound = nil
            }
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
            let identifier = "\(alarm.id)_\(i)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("알림 스케줄링 오류 (\(identifier)): \(error.localizedDescription)")
                } else {
                    print("알림 예약 성공: \(identifier)")
                }
                semaphore.signal()
            }
            semaphore.wait()
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
        let semaphore = DispatchSemaphore(value: 0)
        let center = UNUserNotificationCenter.current()
        
        center.getPendingNotificationRequests { requests in
            let identifiersToRemove = requests.compactMap { request -> String? in
                // 우리가 예약할 때 "\(alarm.id)_\(i)" 형태로 식별자를 생성했으므로,
                // alarmId가 포함된 식별자를 제거하도록 함
                if request.identifier.hasPrefix("\(alarm.id)_") {
                    return request.identifier
                }
                return nil
            }
            
            // 필터링된 식별자들의 알림 제거
            center.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
            print("삭제된 알림 식별자들: \(identifiersToRemove)")
            
            // 비동기 작업 완료 후 시그널 발생
            semaphore.signal()
        }
        
        semaphore.wait()
    }
}

extension Alarm {
    var selectedSoundUrl: URL? {
        R.AlarmSound.allCases.first(where: { $0.title == soundOption.selectedSound })?.alarm
    }
}
