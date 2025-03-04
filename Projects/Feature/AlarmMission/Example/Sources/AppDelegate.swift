//
//  AppDelegate.swift
//

import UIKit
import FeatureAlarmMission

import RIBs

@main
class AppDelegate: UIResponder, UIApplicationDelegate, ExampleRIBListener {

    var window: UIWindow?
    
    var router: ExampleRIBRouting!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationController = UINavigationController()
        let builder = ExampleRIBBuilder(dependency: RootComponent())
        let router = builder.build(withListener: self)
        self.router = router
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [router.viewControllable.uiviewController]
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
    class RootComponent: ExampleRIBDependency {
        
    }
}

