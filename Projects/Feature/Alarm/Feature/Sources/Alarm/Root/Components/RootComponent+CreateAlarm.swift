//
//  RootComponent+CreateEditAlarm.swift
//  FeatureAlarm
//
//  Created by ever on 1/1/25.
//

import Foundation

extension RootComponent: CreateEditAlarmDependency {
    var createAlarmStream: CreateEditAlarmStream {
        createAlarmMutableStream
    }
}
