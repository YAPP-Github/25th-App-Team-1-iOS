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
    func createAlarms(alarms: [Alarm]) -> Result<Void, AlarmControllerError>
    func readAlarms() -> Result<[Alarm], AlarmControllerError>
    func readAlarms(completion: @escaping (Result<[Alarm], AlarmControllerError>) -> ())
    func updateAlarm(alarm: Alarm, completion: ((Result<Void, AlarmControllerError>) -> Void)?)
    func updateAlarm(alarm: Alarm) -> Result<Void, AlarmControllerError>
    func removeAlarm(alarms: [Alarm], completion: ((Result<Void, AlarmControllerError>) -> Void)?)
    func removeAlarm(alarm: Alarm, completion: ((Result<Void, AlarmControllerError>) -> Void)?)
    
    func checkIsAlarmNotification(notiRequestId: String) -> Bool
    func scheduleAlarm(alarm: Alarm)
    func scheduleBackgroundTask(alarm: Alarm)
    func rescheduleActiveAlarmsBackgroundTasks() -> Result<Void, AlarmControllerError>
    
    func unscheduleAlarm(alarm: Alarm)
    func unscheduleExactAlarm(alarm: Alarm)
    func inactivateAlarmWithoutConsecutiveAlarmTask(alarm: Alarm)
}
