//
//  AppDelegate.swift
//

import UIKit
import RIBs
import UserNotifications
import FeatureCommonDependencies

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let launchRouter = MainBuilder(dependency: AppComponent()).build()
        self.launchRouter = launchRouter
        launchRouter.launch(from: window)
        self.window = window
        
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    private var launchRouter: LaunchRouting?
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // 알림의 userInfo나 actionIdentifier를 통해 원하는 분기 처리 가능
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            AlarmManager.shared.stopPlayingSound()
        }
        completionHandler()
    }
}
