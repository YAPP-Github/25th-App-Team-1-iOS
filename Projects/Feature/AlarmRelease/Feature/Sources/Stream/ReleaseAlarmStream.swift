//
//  ReleaseAlarmStream.swift
//  FeatureAlarmRelease
//
//  Created by ever on 7/6/25.
//

import Foundation
import RxSwift

protocol ReleaseAlarmStream {
    var snoozeFinished: Observable<Void> { get }
    var stopTimer: Observable<Void> { get }
}

protocol ReleaseAlarmMutableStream: ReleaseAlarmStream {
    var snoozeFinishedSubject: PublishSubject<Void> { get }
    var stopTimerSubject: PublishSubject<Void> { get }
}

struct ReleaseAlarmStreamImpl: ReleaseAlarmMutableStream {
    // 미루기 옵션
    let snoozeFinishedSubject = PublishSubject<Void>()
    var snoozeFinished: Observable<Void> {
        snoozeFinishedSubject.asObservable()
    }
    
    let stopTimerSubject = PublishSubject<Void>()
    var stopTimer: Observable<Void> {
        stopTimerSubject.asObservable()
    }
    
    
    
}
