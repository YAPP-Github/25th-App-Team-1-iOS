//
//  MainComponent+AlarmRelease.swift
//  Orbit
//
//  Created by ever on 7/15/25.
//

import UIKit
import FeatureAlarmRelease
import FeatureAlarmController
import FeatureLogger

extension MainComponent: FeatureAlarmRelease.RootDependency {
    var presentingViewController: UIViewController {
        // Return the MainPageViewController if it exists, otherwise return the root view controller
        if let mainPageVC = mainRouter?.viewControllable.uiviewController {
            return mainPageVC
        }
        return rootViewController.uiviewController
    }
}
