//
//  AppDelegate.swift
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, RootDependency, RootListener {

    var window: UIWindow?
    
    var rootRouter: RootRouting?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let builder = RootBuilder(dependency: self)
        let router = builder.build(withListener: self)
        self.rootRouter = router
        
        window?.rootViewController = router.viewControllable.uiviewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

