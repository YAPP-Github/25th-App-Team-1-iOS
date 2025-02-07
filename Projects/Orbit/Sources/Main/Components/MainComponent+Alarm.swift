//
//  MainComponent+Alarm.swift
//  Orbit
//
//  Created by ever on 2/7/25.
//

import FeatureAlarm

extension MainComponent: FeatureAlarm.RootDependency {
    var alarmRootViewController: RootViewControllable {
        rootViewController
    }
}
