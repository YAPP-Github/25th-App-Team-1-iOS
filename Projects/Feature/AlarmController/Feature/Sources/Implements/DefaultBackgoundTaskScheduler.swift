//
//  DefaultBackgoundTaskScheduler.swift
//  FeatureAlarmController
//
//  Created by choijunios on 3/8/25.
//

import Foundation

public final class DefaultBackgoundTaskScheduler: BackgoundTaskScheduler {
    // State
    private var workDict: [String: DispatchWorkItem] = [:]
    private let workDictLock = NSLock()
    
    public init() { }
    
    private func register(id: String, workItem: DispatchWorkItem) {
        workDictLock.lock()
        defer { workDictLock.unlock() }
        debugPrint("\(Self.self), register \(id)")
        workDict[id] = workItem
    }
    
    private func checkTaskIsCancelled(id: String) -> Bool {
        workDictLock.lock()
        defer { workDictLock.unlock() }
        if let workItem = workDict[id] {
            return workItem.isCancelled
        }
        return true
    }
    
    private func repeatTask(id: String, date: Date, intervalSeconds: Int, currentCount: Int, limit: Int, task: @escaping (Int) -> Void) {
        let initialInterval = Calendar.current.dateComponents([.second], from: .now, to: date).second!
        let dispatchWallTime = DispatchWallTime.now() + .seconds(initialInterval)
        let dispatchWorkItem: DispatchWorkItem = .init { [weak self] in
            guard let self else { return }
            let executedCount = currentCount + 1
            task(executedCount)
            let nextDate = Calendar.current.date(byAdding: .second, value: intervalSeconds, to: date)!
            if executedCount < limit {
                repeatTask(
                    id: id,
                    date: nextDate,
                    intervalSeconds: intervalSeconds,
                    currentCount: executedCount,
                    limit: limit,
                    task: task
                )
            }
        }
        if checkTaskIsCancelled(id: id) == false {
            DispatchQueue.global().asyncAfter(
                wallDeadline: dispatchWallTime,
                execute: dispatchWorkItem
            )
            register(id: id, workItem: dispatchWorkItem)
        }
    }
}


// MARK: BackgoundTaskScheduler
public extension DefaultBackgoundTaskScheduler {
    func register(id: String, startDate: Date, type: TaskExecutionType, task: @escaping (Int) -> Void) {
        let initialInterval = Calendar.current.dateComponents([.second], from: .now, to: startDate).second!
        let dispatchWallTime = DispatchWallTime.now() + .seconds(initialInterval)
        let dispatchWorkItem: DispatchWorkItem = .init { [weak self] in
            guard let self else { return }
            task(0)
            if case .repeats(let intervalSeconds, let count) = type {
                let nextDate = Calendar.current.date(byAdding: .second, value: intervalSeconds, to: startDate)!
                var repeatCount = 0
                switch count {
                case .limit(let count):
                    repeatCount = count
                case .forever:
                    repeatCount = .max
                }
                if repeatCount > 1 {
                    repeatTask(
                        id: id,
                        date: nextDate,
                        intervalSeconds: intervalSeconds,
                        currentCount: 1,
                        limit: repeatCount,
                        task: task
                    )
                }
            }
        }
        DispatchQueue.global().asyncAfter(
            wallDeadline: dispatchWallTime,
            execute: dispatchWorkItem
        )
        register(id: id, workItem: dispatchWorkItem)
    }
    
    func cancelTask(id: String) {
        workDictLock.lock()
        defer { workDictLock.unlock() }
        workDict[id]?.cancel()
        workDict[id] = nil
        workDict.removeValue(forKey: id)
    }
    
    func cancelTasks(identifiers: [String]) {
        workDictLock.lock()
        defer { workDictLock.unlock() }
        identifiers.forEach { id in
            workDict[id]?.cancel()
            workDict[id] = nil
            debugPrint("\(Self.self), unregister & cancel \(id)")
        }
    }
}
