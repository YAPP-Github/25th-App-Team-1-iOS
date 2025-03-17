//
//  AppComponent.swift
//  Orbit
//
//  Created by 손병근 on 1/4/25.
//

import FeatureAlarmController
import FeatureLogger

import RIBs

class AppComponent: Component<EmptyDependency>, MainDependency {
    // Static
    let alarmController: AlarmController
    let logger: Logger
    
    init(alarmController: AlarmController, logger: Logger) {
        self.alarmController = alarmController
        self.logger = logger
        super.init(dependency: EmptyComponent())
    }
}
