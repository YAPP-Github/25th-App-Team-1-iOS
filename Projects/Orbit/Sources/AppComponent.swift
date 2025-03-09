//
//  AppComponent.swift
//  Orbit
//
//  Created by 손병근 on 1/4/25.
//

import FeatureAlarmController

import RIBs

class AppComponent: Component<EmptyDependency>, MainDependency {
    // Static
    let alarmController: AlarmController
    
    init(alarmController: AlarmController) {
        self.alarmController = alarmController
        super.init(dependency: EmptyComponent())
    }
}
