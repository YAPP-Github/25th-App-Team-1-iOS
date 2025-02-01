//
//  RootComponent+AlarmList.swift
//  FeatureAlarm
//
//  Created by ever on 1/1/25.
//

import Foundation

extension RootComponent: AlarmListDependency {
    var alarmListStream: AlarmListStream {
        return alarmListMutableStream
    }
    
}
