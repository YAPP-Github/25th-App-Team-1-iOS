//
//  AppDelegate.swift
//

import UIKit
import RIBs
import RxSwift
import UserNotifications
import FeatureCommonDependencies
import FeatureMain
import FeatureAlarmCommon
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let (launchRouter, alarmIdHandler) = MainBuilder(dependency: AppComponent()).build()
        self.launchRouter = launchRouter
        self.alarmIdHandler = alarmIdHandler
        launchRouter.launch(from: window)
        self.window = window
        
        UNUserNotificationCenter.current().delegate = self
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yaf.orbit.checkAndScheduleAlarm", using: nil) { task in
            // 백그라운드 작업이 실행될 때 handleBackgroundTask 호출
            AlarmScheduler.shared.handleBackgroundTask(task)
        }
        
        // 백그라운드 작업 등록
        AlarmScheduler.shared.registerBackgroundTask()
        
        
        return true
    }
    
    private var launchRouter: LaunchRouting?
    private var alarmIdHandler: AlarmIdHandler?
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            AudioPlayerManager.shared.stopPlayingSound()
        }
        
        let content = response.notification.request.content
        let userInfo = content.userInfo
        guard let alarmId = userInfo["alarmId"] as? String else {
            completionHandler()
            return
        }
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: Date())
        print("\(components.weekday ?? 0)_\(components.hour ?? 0)_\(components.minute ?? 0)")
        let semaphore = DispatchSemaphore(value: 0)
        center.getPendingNotificationRequests { requests in
            let identifiersToRemove = requests.compactMap { request -> String? in
                // 우리가 예약할 때 "\(alarm.id)_\(i)" 형태로 식별자를 생성했으므로,
                // alarmId가 포함된 식별자를 제거하도록 함
                if request.identifier.hasPrefix("\(alarmId)_") {
                    return request.identifier
                }
                return nil
            }
            
            // 필터링된 식별자들의 알림 제거
            center.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
            print("삭제된 알림 식별자들: \(identifiersToRemove)")
            semaphore.signal()
        }
        semaphore.wait()
        alarmIdHandler?.handle(alarmId)
        completionHandler()
    }
}
