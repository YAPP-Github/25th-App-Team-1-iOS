//
//  MainPageComponent+CreateAlarm.swift
//  FeatureMain
//
//  Created by ever on 2/7/25.
//

import FeatureAlarm

extension MainPageComponent: FeatureAlarm.RootDependency {
    var alarmRootViewController: FeatureAlarm.RootViewControllable {
        viewController
    }
}
