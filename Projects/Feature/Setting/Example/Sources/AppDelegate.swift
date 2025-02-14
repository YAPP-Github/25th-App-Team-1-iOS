//
//  AppDelegate.swift
//

import UIKit

import FeatureCommonEntity
import FeatureSetting

@main
class AppDelegate: UIResponder, UIApplicationDelegate, SettingMainListener {

    var window: UIWindow?
    
    var router: SettingMainRouting?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 테스트 유저 등록
        Preference.userId = 24
        
        let navigationController = UINavigationController()
        let settingBuilder = SettingMainBuilder(dependency: DefaultSettingMainDependency(
            navigationController: navigationController
        ))
        let router = settingBuilder.build(withListener: self)
        self.router = router
        window = UIWindow(frame: UIScreen.main.bounds)
        navigationController.viewControllers = [router.viewControllable.uiviewController]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

class DefaultSettingMainDependency: SettingMainDependency {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
