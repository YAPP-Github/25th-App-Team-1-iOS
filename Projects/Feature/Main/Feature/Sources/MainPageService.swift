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
    private func scheduleNotification(for alarm: Alarm, soundUrl: URL) {
        let center = UNUserNotificationCenter.current()
        
        // 알림 콘텐츠 구성
        let content = UNMutableNotificationContent()
        content.title = "알람"
        content.body = "설정한 알람 시간입니다."
        content.userInfo = ["alarmId": alarm.id]
        if let sound = copySoundFileToLibrary(with: soundUrl) {
            content.sound = sound
        } else {
            content.sound = .default
        }
        
        guard let alarmDate = Calendar.current.date(from: alarm.nextDateComponents()) else {
            print("유효한 날짜를 가져올 수 없습니다.")
            return
        }
        
        let now = Date()
        let initialDelay = alarmDate.timeIntervalSince(now)
        
        // 알람 시간이 이미 지난 경우 처리
        if initialDelay < 0 {
            print("알람 시간이 이미 지난 시간입니다.")
            return
        }
        
        // 첫 알람부터 5초 간격으로 총 64번 예약
        for i in 0..<64 {
            let delay = initialDelay + Double(i * 5)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
            let identifier = "\(alarm.id)_\(i)"
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
