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

import RIBs
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let alarmController = DefaultAlarmController()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let appComponent = AppComponent(alarmController: alarmController)
        let (launchRouter, alarmIdHandler) = MainBuilder(dependency: appComponent).build()
        self.launchRouter = launchRouter
        self.alarmIdHandler = alarmIdHandler
        launchRouter.launch(from: window)
        self.window = window
        
//        UNUserNotificationCenter.current().delegate = self
//        
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yaf.orbit.checkAndScheduleAlarm", using: nil) { task in
//            // 백그라운드 작업이 실행될 때 handleBackgroundTask 호출
//            AlarmScheduler.shared.handleBackgroundTask(task)
//        }
        
        // 백그라운드 작업 등록
//        AlarmScheduler.shared.registerBackgroundTask()
        
        
        // 앱을 종료시키지 않음
        BackgroundMaintainer.shared.activate()
        
        // 백그라운드 테스크 재등록
        alarmController.rescheduleActiveAlarmsBackground { result in
            debugPrint(result)
        }
        let onAlarmRecieved = { [weak self, weak alarmController] (alarm: Alarm) in
            guard let self, let alarmController else { return }
            alarmController.unscheduleAlarm(alarm: alarm)
            alarmIdHandler.handle(alarm.id)
        }
        alarmController.onNotiDeliveredOnForeground = { alarm, completion in
            defer { completion([]) }
            guard let alarm else { return }
            onAlarmRecieved(alarm)
        }
        alarmController.onNotiRecieved = { alarm, completion in
            defer { completion() }
            guard let alarm else { return }
            onAlarmRecieved(alarm)
        }
        
        
        // 앱 종료시 다시 킬 것을 요구하는 노티피케이션 전송
        
        return true
    }
    
    private var launchRouter: LaunchRouting?
    private var alarmIdHandler: AlarmIdHandler?
}


extension AppDelegate {
    
    func onAppTerminate() {
        
        
    }
}


//extension AppDelegate: UNUserNotificationCenterDelegate {
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
