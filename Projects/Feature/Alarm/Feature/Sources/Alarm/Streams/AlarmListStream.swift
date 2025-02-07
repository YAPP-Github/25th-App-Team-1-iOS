//
//  AlarmListStream.swift
//  FeatureAlarm
//
//  Created by ever on 1/1/25.
//

import RxSwift
import FeatureCommonDependencies

protocol AlarmListStream {
    var alarms: Observable<[Alarm]> { get }
}

protocol AlarmListMutableStream: AlarmListStream {
    var mutableAlarm: BehaviorSubject<[Alarm]> { get }
}

struct MutableAlarmListStreamImpl: AlarmListMutableStream {
    let mutableAlarm = BehaviorSubject<[Alarm]>(value: [])
    var alarms: Observable<[Alarm]> {
        mutableAlarm.asObservable()
    }
}
