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
    }
    func updateAlarm(_ alarm: Alarm) {
        AlarmStore.shared.update(alarm)
    }
    func deleteAlarm(_ alarm: Alarm) {
        AlarmStore.shared.delete(alarm)
    }
}

//extension MainPageService {
//    private func scheduleNotification(for alarm: Alarm, soundUrl: URL) {
//        let center = UNUserNotificationCenter.current()
//        
//        // 알림 콘텐츠 구성
//        let content = UNMutableNotificationContent()
//        content.title = "알람"
//        content.body = "설정한 알람 시간입니다."
//        
//        if let soundUrl = copySoundFileToLibrary(with: soundUrl) {
//            // Library/Sounds에 복사된 사운드 파일을 사용
//            content.sound = soundUrl
//        } else {
//            // 복사 실패 시 기본 사운드 사용
//            content.sound = .default
//        }
//
//        // 알림 트리거 구성
//        let dateComponents = alarm.toDateComponents()
//        
//        // 요일에 따라 트리거 설정
//        if !alarm.repeatDays.isEmpty {
//            for weekday in alarm.repeatDays {
//                var weekdayDateComponents = dateComponents
//                weekdayDateComponents.weekday = weekday.intValue // 요일을 Int로 변환 (일요일=1, ...)
//
//                let trigger = UNCalendarNotificationTrigger(dateMatching: weekdayDateComponents, repeats: true)
//
//                let identifier = "\(alarm.id.uuidString)-\(weekday.intValue)"
//                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//                center.add(request) { error in
//                    if let error = error {
//                        print("알림 스케줄링 오류: \(error.localizedDescription)")
//                    } else {
//                        print("알림이 성공적으로 스케줄되었습니다. 식별자: \(identifier)")
//                    }
//                }
//            }
//        } else {
//            // 반복하지 않는 경우
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//            let identifier = alarm.id.uuidString
//            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//            center.add(request) { error in
//                if let error = error {
//                    print("알림 스케줄링 오류: \(error.localizedDescription)")
//                } else {
//                    print("알림이 성공적으로 스케줄되었습니다. 식별자: \(identifier)")
//                }
//            }
//        }
//        
//        let timeInterval = TimeInterval(alarm.snoozeOption.frequency.rawValue * 60)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
//        
//        let identifier = "\(alarm.id)-repeat"
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        
//        center.add(request) { error in
//            if let error = error {
//                print("반복 알림 스케줄링 오류: \(error.localizedDescription)")
//            } else {
//                print("반복 알림이 성공적으로 스케줄되었습니다. 식별자: \(identifier)")
//            }
//        }
//        
//    }
//    @discardableResult
//    func copySoundFileToLibrary(with soundUrl: URL) -> UNNotificationSound? {
//        let fileManager = FileManager.default
//        
//        // Library/Sounds 디렉토리 경로
//        guard let libraryURL = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first else {
//            print("Library 디렉토리를 찾을 수 없습니다.")
//            return nil
//        }
//        let soundsURL = libraryURL.appendingPathComponent("Sounds")
//        
//        // Library/Sounds 디렉토리가 없으면 생성
//        if !fileManager.fileExists(atPath: soundsURL.path) {
//            do {
//                try fileManager.createDirectory(at: soundsURL, withIntermediateDirectories: true, attributes: nil)
//                print("Library/Sounds 디렉토리를 생성했습니다.")
//            } catch {
//                print("Library/Sounds 디렉토리 생성 실패: \(error)")
//                return nil
//            }
//        }
//        
//        // 목적지 파일 URL
//        let destinationURL = soundsURL.appendingPathComponent(soundUrl.lastPathComponent)
//        
//        // 이미 파일이 존재하는지 확인
//        if !fileManager.fileExists(atPath: destinationURL.path) {
//            do {
//                try fileManager.copyItem(at: soundsURL, to: destinationURL)
//                print("사운드 파일을 Library/Sounds로 복사했습니다: \(destinationURL.path)")
//                return UNNotificationSound(named: UNNotificationSoundName(soundUrl.lastPathComponent))
//            } catch {
//                print("사운드 파일 복사 실패: \(error)")
//                return nil
//            }
//        } else {
//            print("사운드 파일이 이미 Library/Sounds에 존재합니다.")
//        }
//        
//        return UNNotificationSound(named: UNNotificationSoundName(soundUrl.lastPathComponent))
//    }
//}
