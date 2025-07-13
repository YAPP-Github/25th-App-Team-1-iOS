//
//  MainPageComponent+AlarmRelease.swift
//  FeatureMain
//
//  Created by ever on 2/11/25.
//

import FeatureAlarmRelease
import FeatureAlarmController

extension MainPageComponent: FeatureAlarmRelease.RootDependency {
    var alarmReleaseRootViewController: FeatureAlarmRelease.RootViewControllable {
        viewController
    }
    var alarmController: AlarmController { dependency.alarmController }
}
