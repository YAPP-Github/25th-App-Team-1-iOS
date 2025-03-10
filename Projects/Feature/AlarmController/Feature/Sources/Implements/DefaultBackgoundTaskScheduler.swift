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
    
    private let repeatWorkContainer = LockedResource<DispatchWorkItem>()
    private let initialTaskContainer = LockedResource<WorkItem>()
    
    public init() {
        startPrivateRunLoop()
    }
    
    private func startPrivateRunLoop() {
        Task {
            while(true) {
                let currentDate = Date.now
                for workItem in initialTaskContainer.getValues() {
                    if workItem.date < currentDate {
                        workItem.task()
                        initialTaskContainer.remove(key: workItem.id)
                    }
                }
                try await Task.sleep(nanoseconds: 1000_000_000 * 5)
            }
        }
    }
    
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
        if let workItem = initialTaskContainer[id] {
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
        
        let workItem = WorkItem(id: id, date: startDate) { [weak self] in
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
        initialTaskContainer.add(key: id, item: workItem)
    }
    
    func cancelTask(matchType: IdMatchingType, id: String) {
        switch matchType {
        case .exact:
            if initialTaskContainer.containsKey(id: id).isEmpty == false {
                initialTaskContainer.remove(key: id)
                debugPrint("\(Self.self), unregister & cancel \(id)")
            }
            
            if repeatWorkContainer.containsKey(id: id).isEmpty == false {
                repeatWorkContainer[id]?.cancel()
                repeatWorkContainer.remove(key: id)
                debugPrint("\(Self.self), unregister & cancel \(id)")
            }
        case .contains:
            let initialTaskKeys = initialTaskContainer.containsKey(id: id)
            if initialTaskKeys.isEmpty == false {
                initialTaskContainer.remove(keys: initialTaskKeys)
            }
            
            repeatWorkContainer.getKeys()
                .filter { $0.contains(id) }
                .forEach { id in
                    repeatWorkContainer[id]?.cancel()
                    repeatWorkContainer.remove(key: id)
                    debugPrint("\(Self.self), unregister & cancel \(id)")
                }
        }
    }
    
    func cancelTasks(matchType: IdMatchingType, identifiers: [String]) {
        switch matchType {
        case .exact:
            initialTaskContainer.remove(keys: identifiers)
        case .contains:
            initialTaskContainer.remove(keys: initialTaskContainer.containsKey(ids: identifiers))
        }
        workDictLock.lock()
        defer { workDictLock.unlock() }
        identifiers.forEach { nolock_cancelTask(matchType: matchType, id: $0) }
    }
    
    private func nolock_cancelTask(matchType: IdMatchingType, id: String) {
        switch matchType {
        case .exact:
            workDict[id]?.cancel()
            workDict.removeValue(forKey: id)
            debugPrint("\(Self.self), unregister & cancel \(id)")
        case .contains:
            workDict.keys
                .filter { $0.contains(id) }
                .forEach { id in
                    workDict[id]?.cancel()
                    workDict.removeValue(forKey: id)
                    debugPrint("\(Self.self), unregister & cancel \(id)")
                }
        }
    }
}
