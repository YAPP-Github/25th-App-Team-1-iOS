//
//  CreateAlarmStream.swift
//  FeatureAlarm
//
//  Created by ever on 1/31/25.
//

import RxSwift

protocol CreateAlarmStream {
    var snoozeOptionChanged: Observable<(SnoozeFrequency?, SnoozeCount?)> { get }
}

protocol CreateAlarmMutableStream: CreateAlarmStream {
    var mutableSnoozeOption: PublishSubject<(SnoozeFrequency?, SnoozeCount?)> { get }
}

struct CreateAlarmMutableStreamImpl: CreateAlarmMutableStream {
    // 미루기 옵션
    let mutableSnoozeOption = PublishSubject<(SnoozeFrequency?, SnoozeCount?)>()
    var snoozeOptionChanged: Observable<(SnoozeFrequency?, SnoozeCount?)> {
        mutableSnoozeOption.asObservable()
    }
    // 사운드 옵션
}
