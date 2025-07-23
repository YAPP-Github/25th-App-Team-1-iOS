//
//  RootComponent+Intro.swift
//  FeatureAlarmRelease
//
//  Created by ever on 7/1/25.
//

import FeatureAlarmController
import FeatureLogger
import FeatureCommonEntity

extension RootComponent: AlarmReleaseIntroDependency {
    var alarmController: AlarmController {
        dependency.alarmController
    }
    
    var logger: Logger {
        dependency.logger
    }
    
    var releaseAlarmStream: ReleaseAlarmStream {
        releaseAlarmMutableStream
    }
}
