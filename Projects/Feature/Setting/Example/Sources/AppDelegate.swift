//
//  AppDelegate.swift
//

import UIKit

@testable import FeatureSetting

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ConfigureUserInfoViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}

