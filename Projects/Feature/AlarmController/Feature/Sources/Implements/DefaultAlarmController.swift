//
//  DefaultAlarmController.swift
//  FeatureAlarmController
//
//  Created by choijunios on 3/6/25.
//

import UserNotifications
import CoreData

import FeatureCommonEntity

import RxSwift

public final class DefaultAlarmController: NSObject, AlarmController, UNUserNotificationCenterDelegate {
    // Dependencies
    private let coreDataService: CoreDataService
    private let alarmScheduler: AlarmScheduler
    
    
    // Util
    private let jsonDecoder = JSONDecoder()
    private let disposeBag = DisposeBag()
    
    public init(
        coreDataService: CoreDataService = DefaultCoreDataService(),
        alarmScheduler: AlarmScheduler = DefaultAlarmScheduler(
            backgoundTaskScheduler: DefaultBackgoundTaskScheduler(),
            alarmAudioController: DefualtAlarmAudioController(),
            vibrationManager: DefaultVibrationManager()
        )) {
        self.coreDataService = coreDataService
        self.alarmScheduler = alarmScheduler
        super.init()
    }
}


// MARK: Alarm CRUD
public extension DefaultAlarmController {
    func createAlarm(alarm: Alarm, completion: ((Result<Void, AlarmControllerError>) -> Void)?) {
        coreDataService.performAsyncTask(type: .background) { [weak self] context, completion in
            guard let self else {
                completion(.failure(AlarmControllerError.dataSavingError))
                return
            }
            do {
                create(alarm: alarm, context: context)
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
        .subscribe(onSuccess: { (result: Result<Void, Error>) in
            switch result {
            case .success:
                completion?(.success(()))
            case .failure(let error):
                debugPrint("\(#function), 알람저장실패: \(error.localizedDescription)")
                completion?(.failure(.dataSavingError))
            }
        })
        .disposed(by: disposeBag)
    }
    
    func createAlarms(alarms: [Alarm]) -> Result<Void, AlarmControllerError> {
        coreDataService.performSyncTask { [weak self] context in
            guard let self else {
                return .failure(AlarmControllerError.dataSavingError)
            }
            for alarm in alarms {
                create(alarm: alarm, context: context)
            }
            do {
                try context.save()
                return .success(())
            } catch {
                debugPrint("\(#function), 알람저장실패: \(error.localizedDescription)")
                return .failure(.dataSavingError)
            }
        }
    }
    
    func readAlarms() -> Result<[Alarm], AlarmControllerError> {
        return coreDataService.performSyncTask { [weak self] context in
            guard let self else { return .failure(AlarmControllerError.dataFetchError) }
            let fetchRequest = AlarmEntity.fetchRequest()
            do {
                let entities = try context.fetch(fetchRequest)
                return .success(entities.map(convert(alarmEntity:)))
            } catch {
                debugPrint("\(#function), 알람획득실패: \(error.localizedDescription)")
                return .failure(AlarmControllerError.dataFetchError)
            }
        }
    }
    
    func readAlarms(completion: @escaping (Result<[Alarm], AlarmControllerError>) -> ()) {
        coreDataService.performAsyncTask(type: .background) { context, completion in
            let fetchRequest = AlarmEntity.fetchRequest()
            do {
                let entities = try context.fetch(fetchRequest)
                completion(.success(entities))
            } catch {
                completion(.failure(error))
            }
        }
        .subscribe { [weak self] (result: Result<[AlarmEntity], Error>) in
            guard let self else { return }
            switch result {
            case .success(let entities):
                let alarms = entities.map(convert(alarmEntity:))
                completion(.success(alarms))
            case .failure(let error):
                debugPrint("\(#function), 알람획득실패: \(error.localizedDescription)")
                completion(.failure(.dataFetchError))
            }
        }
        .disposed(by: disposeBag)
    }
    
    func updateAlarm(alarm: Alarm, completion: ((Result<Void, AlarmControllerError>) -> Void)?) {
        coreDataService.performAsyncTask(type: .background) { context, completion in
            let fetchRequest = AlarmEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", alarm.id)
            do {
                let entities = try context.fetch(fetchRequest)
                guard let alarmEntity = entities.first else { throw AlarmControllerError.dataFetchError }
                
                // #1. Repeat days
                let repeatDays = alarm.repeatDays
                let alarmDaysEntity = alarmEntity.repeatDays!
                if repeatDays.days.isEmpty {
                    alarmDaysEntity.days = nil
                } else {
                    alarmDaysEntity.days = repeatDays.days.map({String($0.rawValue) }).joined(separator: ",")
                }
                alarmDaysEntity.shoundTurnOffHolidayAlarm = repeatDays.shoundTurnOffHolidayAlarm
                
                //#2. Snooze option
                let snoozeOption = alarm.snoozeOption
                let snoozeOptionEntity = alarmEntity.snoozeOption!
                snoozeOptionEntity.count = Int16(snoozeOption.count.rawValue)
                snoozeOptionEntity.frequencyMinute = Int16(snoozeOption.frequency.rawValue)
                snoozeOptionEntity.isOn = snoozeOption.isSnoozeOn
                
                // #3. Sound option
                let soundOption = alarm.soundOption
                let soundOptionEntity = alarmEntity.soundOption!
                soundOptionEntity.isSoundOn = soundOption.isSoundOn
                soundOptionEntity.isVibrationOn = soundOption.isVibrationOn
                soundOptionEntity.selectedSound = soundOption.selectedSound
                soundOptionEntity.volume = soundOption.volume
                
                // #4. Alarm
                alarmEntity.id = alarm.id
                alarmEntity.meridiem = alarm.meridiem.rawValue
                alarmEntity.hour = Int16(alarm.hour.value)
                alarmEntity.minute = Int16(alarm.minute.value)
                alarmEntity.isActive = alarm.isActive
                
                try context.save()
            } catch {
                completion(.failure(error))
            }
        }
        .subscribe(onSuccess: { (result: Result<Void, Error>) in
            switch result {
            case .success:
                completion?(.success(()))
            case .failure(let error):
                debugPrint("\(#function), 알람수정실패: \(error.localizedDescription)")
                if let alarmManagerErr = error as? AlarmControllerError {
                    completion?(.failure(alarmManagerErr))
                } else {
                    completion?(.failure(.dataSavingError))
                }
            }
        })
        .disposed(by: disposeBag)
    }
    
    func removeAlarm(alarm: Alarm, completion: ((Result<Void, AlarmControllerError>) -> Void)?) {
        coreDataService.performAsyncTask(type: .background) { context, completion in
            let fetchRequest = AlarmEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", alarm.id)
            do {
                let entities = try context.fetch(fetchRequest)
                guard let alarmEntity = entities.first else { throw AlarmControllerError.dataFetchError }
                context.delete(alarmEntity)
                try context.save()
            } catch {
                completion(.failure(error))
            }
        }
        .subscribe(onSuccess: { (result: Result<Void, Error>) in
            switch result {
            case .success:
                completion?(.success(()))
            case .failure(let error):
                debugPrint("\(#function), 알람삭제실패: \(error.localizedDescription)")
                if let alarmManagerErr = error as? AlarmControllerError {
                    completion?(.failure(alarmManagerErr))
                } else {
                    completion?(.failure(.dataSavingError))
                }
            }
        })
        .disposed(by: disposeBag)
    }
    
    func removeAlarm(alarms: [Alarm], completion: ((Result<Void, AlarmControllerError>) -> Void)?) {
        coreDataService.performAsyncTask(type: .background) { context, completion in
            let fetchRequest = AlarmEntity.fetchRequest()
            let alarmIds = alarms.map({ $0.id })
            fetchRequest.predicate = NSPredicate(format: "id IN %@", alarmIds)
            do {
                let entities = try context.fetch(fetchRequest)
                guard entities.isEmpty == false else { throw AlarmControllerError.dataFetchError }
                entities.forEach(context.delete(_:))
                try context.save()
            } catch {
                completion(.failure(error))
            }
        }
        .subscribe(onSuccess: { (result: Result<Void, Error>) in
            switch result {
            case .success:
                completion?(.success(()))
            case .failure(let error):
                debugPrint("\(#function), 알람삭제실패: \(error.localizedDescription)")
                if let alarmManagerErr = error as? AlarmControllerError {
                    completion?(.failure(alarmManagerErr))
                } else {
                    completion?(.failure(.dataSavingError))
                }
            }
        })
        .disposed(by: disposeBag)
    }
}


// MARK: Alarm Scheduling
public extension DefaultAlarmController {
    func checkIsNotificationAlarm(id: String) -> Bool {
        id.contains(KeyGenerator.notification(alarmId: ""))
    }
    
    func scheduleAlarm(alarm: Alarm) {
        alarmScheduler.schedule(contents: .all, alarm: alarm)
    }
    
    func scheduleBackgroundTask(alarm: Alarm) {
        alarmScheduler.schedule(
            contents: .backgroundTasks,
            alarm: alarm
        )
    }
    
    func unscheduleAlarm(alarm: Alarm) {
        alarmScheduler.inactivateSchedule(contents: .all, alarm: alarm)
    }
    
    func inactivateAlarmLocalNotifications(alarm: Alarm) {
        alarmScheduler.inactivateSchedule(
            contents: [
                .initialLocalNotification,
                .registerLocalNotificationRepeatedly
            ],
            alarm: alarm
        )
    }
    
    func inactivateAlarmBackgroundTask(alarm: Alarm) {
        alarmScheduler.inactivateSchedule(
            contents: .backgroundTasks,
            alarm: alarm
        )
    }
    
    func rescheduleActiveAlarmsBackgroundTasks() -> Result<Void, AlarmControllerError> {
        switch readAlarms() {
        case .success(let alarms):
            alarms
                .filter(\.isActive)
                .forEach(scheduleBackgroundTask(alarm:))
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}


// MARK: Convert entity to Alarm
private extension DefaultAlarmController {
    /// 호출쓰레드와 context큐 or 쓰레드가 반드시 일치해야한다.
    @discardableResult
    func create(alarm: Alarm, context: NSManagedObjectContext) -> AlarmEntity {
        
        // #1. Repeat days
        let repeatDays = alarm.repeatDays
        let alarmDaysEntity = AlarmDaysEntity(context: context)
        if repeatDays.days.isEmpty {
            alarmDaysEntity.days = nil
        } else {
            alarmDaysEntity.days = repeatDays.days.map({String($0.rawValue) }).joined(separator: ",")
        }
        alarmDaysEntity.shoundTurnOffHolidayAlarm = repeatDays.shoundTurnOffHolidayAlarm
        
        //#2. Snooze option
        let snoozeOption = alarm.snoozeOption
        let snoozeOptionEntity = SnoozeOptionEntity(context: context)
        snoozeOptionEntity.count = Int16(snoozeOption.count.rawValue)
        snoozeOptionEntity.frequencyMinute = Int16(snoozeOption.frequency.rawValue)
        snoozeOptionEntity.isOn = snoozeOption.isSnoozeOn
        
        // #3. Sound option
        let soundOption = alarm.soundOption
        let soundOptionEntity = SoundOptionEntity(context: context)
        soundOptionEntity.isSoundOn = soundOption.isSoundOn
        soundOptionEntity.isVibrationOn = soundOption.isVibrationOn
        soundOptionEntity.selectedSound = soundOption.selectedSound
        soundOptionEntity.volume = soundOption.volume
        
        // #4. Alarm
        let alarmEntity = AlarmEntity(context: context)
        alarmEntity.id = alarm.id
        alarmEntity.meridiem = alarm.meridiem.rawValue
        alarmEntity.hour = Int16(alarm.hour.value)
        alarmEntity.minute = Int16(alarm.minute.value)
        alarmEntity.isActive = alarm.isActive
        
        // - Releation
        alarmEntity.repeatDays = alarmDaysEntity
        alarmEntity.snoozeOption = snoozeOptionEntity
        alarmEntity.soundOption = soundOptionEntity
        
        return alarmEntity
    }
    
    func convert(alarmEntity: AlarmEntity) -> Alarm {
        // #1. repeatDays
        let repeatDaysEntity = alarmEntity.repeatDays!
        var alarmDays = AlarmDays(
            days: {
                guard let days = repeatDaysEntity.days else { return .init() }
                
                let weekDaysArr = days.split(separator: ",").compactMap { subStr in
                    if let rawValue = Int(subStr) {
                        return WeekDay(rawValue: rawValue)
                    }
                    return nil
                }
                return Set(weekDaysArr)
            }()
        )
        alarmDays.shoundTurnOffHolidayAlarm = repeatDaysEntity.shoundTurnOffHolidayAlarm
        
        // #2. Snooze option
        let snoozeOptionEntity = alarmEntity.snoozeOption!
        let snoozeOption = SnoozeOption(
            isSnoozeOn: snoozeOptionEntity.isOn,
            frequency: {
                let rawValue = Int(snoozeOptionEntity.frequencyMinute)
                return SnoozeFrequency(rawValue: rawValue)!
            }(),
            count: {
                let rawValue = Int(snoozeOptionEntity.count)
                return SnoozeCount(rawValue: rawValue)!
            }()
        )
        
        // #3. Sound option
        let soundOptionEntity = alarmEntity.soundOption!
        let soundOption = SoundOption(
            isVibrationOn: soundOptionEntity.isVibrationOn,
            isSoundOn: soundOptionEntity.isSoundOn,
            volume: soundOptionEntity.volume,
            selectedSound: soundOptionEntity.selectedSound!
        )
        
        // #4. Alarm
        let alarm = Alarm(
            id: alarmEntity.id!,
            meridiem: Meridiem(rawValue: alarmEntity.meridiem!)!,
            hour: Hour(Int(alarmEntity.hour))!,
            minute: Minute(Int(alarmEntity.minute))!,
            repeatDays: alarmDays,
            snoozeOption: snoozeOption,
            soundOption: soundOption,
            isActive: alarmEntity.isActive
        )
        return alarm
    }
}
