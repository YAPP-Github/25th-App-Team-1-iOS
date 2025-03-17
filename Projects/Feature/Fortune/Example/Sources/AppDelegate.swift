//
//  AppDelegate.swift
//

import UIKit

@testable import FeatureFortune

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
//        let navigationController = UINavigationController(rootViewController: ViewController())
//        window?.rootViewController = navigationController
//        window?.makeKeyAndVisible()
        
        return true
    }
}

