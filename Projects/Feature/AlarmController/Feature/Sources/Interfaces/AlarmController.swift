//
//  AlarmController.swift
//  FeatureAlarmController
//
//  Created by choijunios on 3/6/25.
//

import FeatureCommonEntity

public protocol AlarmController {
    // - Alarm CRUD
    func createAlarm(alarm: Alarm, completion: ((Result<Void, AlarmControllerError>) -> Void)?)
    func readAlarms(completion: @escaping (Result<[Alarm], AlarmControllerError>) -> ())
    func updateAlarm(alarm: Alarm, completion: ((Result<Void, AlarmControllerError>) -> Void)?)
    func removeAlarm(alarms: [Alarm], completion: ((Result<Void, AlarmControllerError>) -> Void)?)
    func removeAlarm(alarm: Alarm, completion: ((Result<Void, AlarmControllerError>) -> Void)?)
    
    func scheduleAlarm(alarm: Alarm)
    func scheduleActiveAlarms(completion: ((Result<Void, AlarmControllerError>) -> Void)?)
    func unscheduleAlarm(alarm: Alarm)
}
