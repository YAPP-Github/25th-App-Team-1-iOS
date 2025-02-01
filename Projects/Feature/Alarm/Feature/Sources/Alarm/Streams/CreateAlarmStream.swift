//
//  CreateAlarmStream.swift
//  FeatureAlarm
//
//  Created by ever on 1/31/25.
//

import RxSwift
import FeatureResources

protocol CreateAlarmStream {
    var snoozeOptionChanged: Observable<(SnoozeFrequency?, SnoozeCount?)> { get }
    var soundOptionChanged: Observable<(isVibrateOn: Bool, isSoundOn: Bool, volume: Float, selectedSound: R.AlarmSound?)> { get }
}

protocol CreateAlarmMutableStream: CreateAlarmStream {
    var mutableSnoozeOption: PublishSubject<(SnoozeFrequency?, SnoozeCount?)> { get }
    var mutableSoundOption: PublishSubject<(isVibrateOn: Bool, isSoundOn: Bool, volume: Float, selectedSound: R.AlarmSound?)> { get }
}

struct CreateAlarmMutableStreamImpl: CreateAlarmMutableStream {
    // 미루기 옵션
    let mutableSnoozeOption = PublishSubject<(SnoozeFrequency?, SnoozeCount?)>()
    var snoozeOptionChanged: Observable<(SnoozeFrequency?, SnoozeCount?)> {
        mutableSnoozeOption.asObservable()
    }
    // 사운드 옵션
    let mutableSoundOption = PublishSubject<(isVibrateOn: Bool, isSoundOn: Bool, volume: Float, selectedSound: R.AlarmSound?)>()
    var soundOptionChanged: Observable<(isVibrateOn: Bool, isSoundOn: Bool, volume: Float, selectedSound: R.AlarmSound?)> {
        mutableSoundOption.asObservable()
    }
}
