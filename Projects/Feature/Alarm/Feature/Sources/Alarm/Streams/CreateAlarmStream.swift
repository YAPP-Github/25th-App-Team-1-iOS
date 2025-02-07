//
//  CreateEditAlarmStream.swift
//  FeatureAlarm
//
//  Created by ever on 1/31/25.
//

import RxSwift
import FeatureResources
import FeatureCommonDependencies

protocol CreateEditAlarmStream {
    var snoozeOptionChanged: Observable<SnoozeOption> { get }
    var soundOptionChanged: Observable<SoundOption> { get }
}

protocol CreateEditAlarmMutableStream: CreateEditAlarmStream {
    var mutableSnoozeOption: PublishSubject<SnoozeOption> { get }
    var mutableSoundOption: PublishSubject<SoundOption> { get }
}

struct CreateEditAlarmMutableStreamImpl: CreateEditAlarmMutableStream {
    // 미루기 옵션
    let mutableSnoozeOption = PublishSubject<SnoozeOption>()
    var snoozeOptionChanged: Observable<SnoozeOption> {
        mutableSnoozeOption.asObservable()
    }
    // 사운드 옵션
    let mutableSoundOption = PublishSubject<SoundOption>()
    var soundOptionChanged: Observable<SoundOption> {
        mutableSoundOption.asObservable()
    }
}
