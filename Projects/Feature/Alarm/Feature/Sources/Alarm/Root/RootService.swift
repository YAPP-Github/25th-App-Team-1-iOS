//
//  RootService.swift
//  FeatureAlarm
//
//  Created by ever on 1/1/25.
//

import UserNotifications
import FeatureDesignSystem

protocol RootServiceable {
    func createAlarm(_ alarm: Alarm)
}

struct RootService: RootServiceable {
    func createAlarm(_ alarm: Alarm) {
        requestNotificationAuthorization { granted, error in
            if granted {
                scheduleNotification(for: alarm)
            } else {
                if let error = error {
                    print("알림 권한 요청 오류: \(error.localizedDescription)")
                } else {
                    print("알림 권한이 거부되었습니다.")
                }
            }
        }
    }
    
    private func scheduleNotification(for alarm: Alarm) {
        let center = UNUserNotificationCenter.current()
        
        // 알림 콘텐츠 구성
        let content = UNMutableNotificationContent()
        content.title = "알람"
        content.body = "설정한 알람 시간입니다."
        let copySuccess = copySoundFileToLibrary()
        if copySuccess {
            // Library/Sounds에 복사된 사운드 파일을 사용
            content.sound = UNNotificationSound(named: UNNotificationSoundName("alarm.caf"))
        } else {
            // 복사 실패 시 기본 사운드 사용
            content.sound = .default
        }
        
        // 알림 트리거 구성
        var dateComponents = DateComponents()
        dateComponents.hour = alarm.toDateComponents().hour
        dateComponents.minute = alarm.toDateComponents().minute
        
        // 요일에 따라 트리거 설정
        if !alarm.repeatDays.isEmpty {
            for weekday in alarm.repeatDays {
                var weekdayDateComponents = dateComponents
                weekdayDateComponents.weekday = weekday.intValue // 요일을 Int로 변환 (일요일=1, ...)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: weekdayDateComponents, repeats: true)
                
                let identifier = "\(alarm.id.uuidString)-\(weekday.rawValue)"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error = error {
                        print("알림 스케줄링 오류: \(error.localizedDescription)")
                    } else {
                        print("알림이 성공적으로 스케줄되었습니다. 식별자: \(identifier)")
                    }
                }
            }
        } else {
            // 반복하지 않는 경우
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let identifier = alarm.id.uuidString
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("알림 스케줄링 오류: \(error.localizedDescription)")
                } else {
                    print("알림이 성공적으로 스케줄되었습니다. 식별자: \(identifier)")
                }
            }
        }
        
        // 반복 간격이 있는 경우 (3분 또는 5분)
        if alarm.repetitionInterval != .none {
            let timeInterval = TimeInterval(alarm.repetitionInterval.rawValue * 60)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
            
            let identifier = "\(alarm.id.uuidString)-repeat"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("반복 알림 스케줄링 오류: \(error.localizedDescription)")
                } else {
                    print("반복 알림이 성공적으로 스케줄되었습니다. 식별자: \(identifier)")
                }
            }
        }
    }
    
    private func requestNotificationAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            completion(granted, error)
        }
    }
}

extension RootService {
    func copySoundFileToLibrary() -> Bool {
        // 다른 번들에서 사운드 파일 URL 가져오기
        let soundURL = R.Sound.alarm
        
        let fileManager = FileManager.default
        
        // Library/Sounds 디렉토리 경로
        guard let libraryURL = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            print("Library 디렉토리를 찾을 수 없습니다.")
            return false
        }
        let soundsURL = libraryURL.appendingPathComponent("Sounds")
        
        // Library/Sounds 디렉토리가 없으면 생성
        if !fileManager.fileExists(atPath: soundsURL.path) {
            do {
                try fileManager.createDirectory(at: soundsURL, withIntermediateDirectories: true, attributes: nil)
                print("Library/Sounds 디렉토리를 생성했습니다.")
            } catch {
                print("Library/Sounds 디렉토리 생성 실패: \(error)")
                return false
            }
        }
        
        // 목적지 파일 URL
        let destinationURL = soundsURL.appendingPathComponent("alarm.caf")
        
        // 이미 파일이 존재하는지 확인
        if !fileManager.fileExists(atPath: destinationURL.path) {
            do {
                try fileManager.copyItem(at: soundURL, to: destinationURL)
                print("사운드 파일을 Library/Sounds로 복사했습니다: \(destinationURL.path)")
            } catch {
                print("사운드 파일 복사 실패: \(error)")
                return false
            }
        } else {
            print("사운드 파일이 이미 Library/Sounds에 존재합니다.")
        }
        
        return true
    }
}
