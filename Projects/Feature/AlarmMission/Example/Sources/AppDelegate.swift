//
//  AppDelegate.swift
//

import UIKit
import FeatureAlarmMission

@main
class AppDelegate: UIResponder, UIApplicationDelegate, ShakeMissionMainListener {

    var window: UIWindow?
    
    var router: ShakeMissionMainRouting!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationController = UINavigationController()
        let builder = ShakeMissionMainBuilder(dependency: RootComponent())
        let router = builder.build(withListener: self)
        self.router = router
        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [
            router.viewControllable.uiviewController
        ]
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
    class RootComponent: ShakeMissionMainDependency {}
    
    func request(_ request: ShakeMissionMainListenerRequest) {
        switch request {
        case .close:
            window?.rootViewController?.dismiss(animated: true
            )
        }
    }
}

