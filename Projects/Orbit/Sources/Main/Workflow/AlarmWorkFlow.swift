//
//  AlarmWorkFlow.swift
//  Orbit
//
//  Created by ever on 2/11/25.
//

import FeatureAlarmRelease
import FeatureAlarmController

import RIBs
import RxSwift
import Foundation

final class AlarmWorkFlow: Workflow<RootActionableItem> {
    private let alarmId: String
    
    init(alarmId: String) {
        self.alarmId = alarmId
        super.init()
        
        self
            .onStep { (rootItem: RootActionableItem) -> Observable<(RootActionableItem, ())> in
                rootItem.waitForOnboarding()
                    .map { (_, _) in (rootItem, ()) }
            }
            .onStep { [weak self] (rootItem: RootActionableItem, _) -> Observable<(RootActionableItem, Void)> in
                guard let self else { return .empty() }
                return self.triggerAlarmRelease(rootItem: rootItem)
                    .map { (rootItem, $0) } 
            }
            .commit()
    }
    
    private func triggerAlarmRelease(rootItem: RootActionableItem) -> Observable<Void> {
        return Observable.create { observer in
            // Get alarm from controller
            let alarmController = rootItem.alarmController
            let alarmResult = alarmController.readAlarms()
            
            switch alarmResult {
            case .success(let alarms):
                guard let alarm = alarms.first(where: { $0.id == self.alarmId }) else {
                    observer.onError(NSError(domain: "AlarmNotFound", code: 404))
                    return Disposables.create()
                }
                
                // Determine if this is the first alarm
                let activeAlarms = alarms.filter(\.isActive)
                let isFirstAlarm = activeAlarms.sorted { alarm1, alarm2 in
                    let time1 = alarm1.hour.to24Hour(with: alarm1.meridiem) * 60 + alarm1.minute.value
                    let time2 = alarm2.hour.to24Hour(with: alarm2.meridiem) * 60 + alarm2.minute.value
                    return time1 < time2
                }.first?.id == alarm.id
                
                // Route directly to AlarmRelease
                rootItem.routeToAlarmRelease(alarm: alarm, isFirstAlarm: isFirstAlarm)
                observer.onNext(())
                observer.onCompleted()
                
            case .failure(let error):
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
}
