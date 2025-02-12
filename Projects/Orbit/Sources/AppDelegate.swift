//
//  AppDelegate.swift
//

import UIKit
import RIBs
import RxSwift
import UserNotifications
import FeatureCommonDependencies
import FeatureMain

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
            AlarmManager.shared.stopPlayingSound()
        }
        
        let content = response.notification.request.content
        let userInfo = content.userInfo
        guard let alarmId = userInfo["alarmId"] as? String else {
            completionHandler()
            return
        }
        
        alarmIdHandler?.handle(alarmId)
        
        completionHandler()
    }
}
