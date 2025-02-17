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
        let now = Date()
        
        for components in alarmComponentsList {
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            
            let content = UNMutableNotificationContent()
            content.title = "알람"
            content.body = "선택한 요일에 울리는 알람입니다."
            content.userInfo = ["alarmId": alarm.id]
            content.sound = sound
            
            guard let alarmDate = Calendar.current.date(from: components) else { continue }
            let initialDelay = alarmDate.timeIntervalSince(now)
            
            if initialDelay < 0 {
                continue
            }
            
            // 식별자에 요일 정보를 포함하면 관리하기 편함
            let identifier = "\(alarm.id)_\(components.weekday ?? 0)_\(components.hour ?? 0)_\(components.minute ?? 0)"
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("알림 예약 실패 (\(identifier)): \(error.localizedDescription)")
                } else {
                    print("알림 예약 성공: \(identifier)")
                }
            }
            
            for i in 0..<64 {
                let delay = initialDelay + Double(i * 5)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
                let identifier = "\(alarm.id)_\(components.weekday ?? 0)_\(components.hour ?? 0)_\(components.minute ?? 0)_\(i)"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error = error {
                        print("알림 스케줄링 오류 (\(identifier)): \(error.localizedDescription)")
                    } else {
                        print("알림 예약 성공: \(identifier)")
                    }
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
}
