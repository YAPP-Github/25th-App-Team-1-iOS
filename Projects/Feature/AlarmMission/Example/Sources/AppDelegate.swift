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
        
        let navigationController = UINavigationController()
        let builder = ShakeMissionMainBuilder(dependency: RootComponent(
            navigationController: navigationController
        ))
        let router = builder.build(withListener: self)
        self.router = router
        navigationController.viewControllers = [
            router.viewControllable.uiviewController
        ]
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        
        return true
    }
    
    class RootComponent: ShakeMissionMainDependency {
        let navigationController: UINavigationController
        
        init(navigationController: UINavigationController) {
            self.navigationController = navigationController
        }
    }
}

