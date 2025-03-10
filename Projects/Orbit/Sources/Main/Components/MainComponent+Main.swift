//
//  MainComponent+Main.swift
//  Orbit
//
//  Created by ever on 2/7/25.
//

import FeatureMain
import FeatureAlarmController

extension MainComponent: MainPageDependency {
    var alarmController: AlarmController { dependency.alarmController }
}
