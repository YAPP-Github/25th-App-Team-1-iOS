//
//  AppDelegate.swift
//

import UIKit
@testable import FeatureAlarmMission

@main
class AppDelegate: UIResponder, UIApplicationDelegate, ShakeMissionMainListener {

    var window: UIWindow?
    
    var router: ShakeMissionMainRouting!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let builder = ShakeMissionMainBuilder(dependency: RootComponent())
        self.router = builder.build(withListener: self)
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = router.viewControllable.uiviewController
        window?.makeKeyAndVisible()
        
        
        return true
    }
    
    class RootComponent: ShakeMissionMainDependency {
        
    }
}

