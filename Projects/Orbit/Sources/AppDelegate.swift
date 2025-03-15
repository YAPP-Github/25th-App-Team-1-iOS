//
//  AppDelegate.swift
//

import UIKit
import UserNotifications

import FeatureCommonDependencies
import FeatureMain
import FeatureAlarmCommon
import FeatureAlarmController
import BackgroundTasks
import FeatureRemoteConfig

import RIBs
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase
        configureFirebase()
        
        let alarmController = DefaultAlarmController()
        self.alarmController = alarmController
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let appComponent = AppComponent(alarmController: alarmController)
        let (launchRouter, alarmIdHandler) = MainBuilder(dependency: appComponent).build()
        self.launchRouter = launchRouter
        self.alarmIdHandler = alarmIdHandler
        launchRouter.launch(from: window)
        self.window = window
        
        UNUserNotificationCenter.current().delegate = self
        
//
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yaf.orbit.checkAndScheduleAlarm", using: nil) { task in
//            // 백그라운드 작업이 실행될 때 handleBackgroundTask 호출
//            AlarmScheduler.shared.handleBackgroundTask(task)
//        }
        
        // 백그라운드 작업 등록
//        AlarmScheduler.shared.registerBackgroundTask()
        
        
        // MARK: Migrantion UserDefaults --> CoreData
        migrateAlarms()
        
        
        // 앱을 종료시키지 않음
        BackgroundMaintainer.shared.activate()
        
        // 백그라운드 테스크 재등록
        let result = alarmController.rescheduleActiveAlarmsBackgroundTasks()
        switch result {
        case .success:
            debugPrint("앱실행시 알람 재스캐쥴링 성공")
        case .failure(let error):
            debugPrint("앱실행시 알람 재스캐쥴링 실패 \(error.localizedDescription)")
        }
        return true
    }
    
    private var launchRouter: LaunchRouting?
    private var alarmIdHandler: AlarmIdHandler?
    
    private var alarmController: AlarmController?
    private let jsonDecoder = JSONDecoder()
}


// MARK: Alarm migration
extension AppDelegate {
    func migrateAlarms() {
        guard let alarmController else { fatalError() }
        let alarmMigrationKey = "alarmMigrationFinished"
        let isAlarmMigrationed = UserDefaults.standard.bool(forKey: alarmMigrationKey)
        if isAlarmMigrationed == false {
            let alarms = AlarmStore.shared.getAll()
            let result = alarmController.createAlarms(alarms: alarms)
            switch result {
            case .success:
                alarms.forEach(AlarmStore.shared.delete)
                UserDefaults.standard.set(true, forKey: alarmMigrationKey)
                debugPrint("알람데이터 미그레이션 성공")
            case .failure(let error):
                debugPrint("알람데이터 미그레이션 실패 \(error.localizedDescription)")
            }
        }
    }
}


// MARK: Application lifecycle event
extension AppDelegate {
    func applicationWillEnterForeground(_ application: UIApplication) {
        // 리모트 컨피그 갱신
        fetchAndActivateRemoteConfig()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // MARK: 엑티브 상태의 알람이 있는 경우 앱재실행 노티피케이션 표출
        if case .success(let alarms) = alarmController?.readAlarms() {
            for alarm in alarms {
                if alarm.isActive {
                    let notificationContent = UNMutableNotificationContent()
                    notificationContent.title = "앱을 종료하면 알람을 들을 수 없어요"
                    notificationContent.body = "알람을 눌러 앱을 다시 켜주세요!"
                    
                    let calendar = Calendar.current
                    let notificationDate = calendar.date(byAdding: .second, value: 2, to: .now)!
                    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationDate)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                    
                    let request = UNNotificationRequest(
                        identifier: "recommend_reopen_app",
                        content: notificationContent,
                        trigger: trigger
                    )
                    let notificationCenter = UNUserNotificationCenter.current()
                    notificationCenter.add(request)
                    break
                }
            }
        }
    }
}


// MARK: Handle local notification events
extension AppDelegate {
    func handleAlarmNotification(notification: UNNotification) {
        guard let codable = notification.request.content.userInfo["alarm"] as? Data,
              let alarm = try? jsonDecoder.decode(Alarm.self, from: codable) else { return }
        alarmIdHandler?.handle(alarm.id)
    }
}


// MARK: UNUserNotificationCenterDelegate
extension AppDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notification = response.notification
        let requestId = response.notification.request.identifier
        if alarmController?.checkIsAlarmNotification(notiRequestId: requestId) == true {
            handleAlarmNotification(notification: notification)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let requestId = notification.request.identifier
        if alarmController?.checkIsAlarmNotification(notiRequestId: requestId) == true {
            handleAlarmNotification(notification: notification)
        }
    }
}


// MARK: Firebase
private extension AppDelegate {
    func configureFirebase() {
        FirebaseApp.configure()
        debugPrint("Firebase app 설정 완료")
        
        // Setup remote config
        do {
            let config = RemoteConfig.remoteConfig()
            let settings = RemoteConfigSettings()
            settings.minimumFetchInterval = 0
            config.configSettings = settings
            try config.setDefaults(from: [
                "alarm_mission_type": "shake_mission"
            ])
            config.fetchAndActivate()
        } catch {
            debugPrint("Remote config 기본값 설정 오류 \(error.localizedDescription)")
        }
    }
    
    func fetchAndActivateRemoteConfig() {
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetchAndActivate { _, error in
            if let error {
                debugPrint("Remote cofig fetch error \(error.localizedDescription)")
            }
        }
    }
}


//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        
//        
//        
//        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
//            AudioPlayerManager.shared.stopPlayingSound()
//        }
//        
//        let content = response.notification.request.content
//        let userInfo = content.userInfo
//        guard let alarmId = userInfo["alarmId"] as? String else {
//            completionHandler()
//            return
//        }
//        
//        let components = Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: Date())
//        print("\(components.weekday ?? 0)_\(components.hour ?? 0)_\(components.minute ?? 0)")
//        let semaphore = DispatchSemaphore(value: 0)
//        center.getPendingNotificationRequests { requests in
//            let identifiersToRemove = requests.compactMap { request -> String? in
//                // 우리가 예약할 때 "\(alarm.id)_\(i)" 형태로 식별자를 생성했으므로,
//                // alarmId가 포함된 식별자를 제거하도록 함
//                if request.identifier.hasPrefix("\(alarmId)_") {
//                    return request.identifier
//                }
//                return nil
//            }
//            
//            // 필터링된 식별자들의 알림 제거
//            center.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
//            print("삭제된 알림 식별자들: \(identifiersToRemove)")
//            semaphore.signal()
//        }
//        semaphore.wait()
//        alarmIdHandler?.handle(alarmId)
//        completionHandler()
//    }
//}
