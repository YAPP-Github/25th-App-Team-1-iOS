//
//  FakeAlarmController.swift
//  Main
//
//  Created by choijunios on 3/26/25.
//

import FeatureAlarmController
import FeatureCommonEntity

final class FakeAlarmController: AlarmController {
    
    private var alarmContainer: [String: Alarm] = [:]
    
    func createAlarm(alarm: Alarm, completion: ((Result<Void, AlarmControllerError>) -> Void)?) {
        alarmContainer[alarm.id] = alarm
        completion?(.success(()))
    }
    
    func createAlarms(alarms: [Alarm]) -> Result<Void, AlarmControllerError> {
        alarms.forEach { alarm in
            alarmContainer[alarm.id] = alarm
        }
        return .success(())
    }
    
    func readAlarms() -> Result<[Alarm], AlarmControllerError> {
        return .success(Array(alarmContainer.values))
    }
    
    func readAlarms(completion: @escaping (Result<[Alarm], AlarmControllerError>) -> ()) {
        completion(.success(Array(alarmContainer.values)))
    }
    
    func updateAlarm(alarm: Alarm, completion: ((Result<Void, AlarmControllerError>) -> Void)?) {
        alarmContainer[alarm.id] = alarm
        completion?(.success(()))
    }
    
    func updateAlarm(alarm: Alarm) -> Result<Void, AlarmControllerError> {
        alarmContainer[alarm.id] = alarm
        return .success(())
    }
    
    func removeAlarm(alarms: [Alarm], completion: ((Result<Void, AlarmControllerError>) -> Void)?) {
        alarms.forEach { alarm in
            alarmContainer.removeValue(forKey: alarm.id)
        }
        completion?(.success(()))
    }
    
    func removeAlarm(alarm: Alarm, completion: ((Result<Void, AlarmControllerError>) -> Void)?) {
        alarmContainer.removeValue(forKey: alarm.id)
        completion?(.success(()))
    }
}


// MARK: Schedule
extension FakeAlarmController {
    func checkIsAlarmNotification(notiRequestId: String) -> Bool { true }
    func scheduleAlarm(alarm: Alarm) { }
    func scheduleBackgroundTask(alarm: Alarm) { }
    func rescheduleActiveAlarmsBackgroundTasks() -> Result<Void, AlarmControllerError> {
        return .success(())
    }
    func unscheduleAlarm(alarm: Alarm) { }
    func unscheduleExactAlarm(alarm: Alarm) { }
    func inactivateAlarmWithoutConsecutiveAlarmTask(alarm: Alarm) { }
}
