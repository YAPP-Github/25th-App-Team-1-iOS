//
//  DefaultBackgoundTaskScheduler.swift
//  FeatureAlarmController
//
//  Created by choijunios on 3/8/25.
//

import Foundation

public final class DefaultBackgoundTaskScheduler: BackgoundTaskScheduler {
    // State
    private let repeatWorkContainer = WorkContainer<DispatchWorkItem>()
    private let initialTaskContainer = WorkContainer<WorkItem>()
    
    public init() {
        startPrivateRunLoop()
    }
    
    private func startPrivateRunLoop() {
        Task {
            while(true) {
                let currentDate = Date.now
                for workItem in initialTaskContainer.getValues() {
                    if workItem.date < currentDate, !workItem.isCancelled {
                        workItem.task()
                        initialTaskContainer.cancelAndRemove(key: workItem.id)
                    }
                }
                try await Task.sleep(nanoseconds: 1000_000_000 * 5)
            }
        }
    }
    
    private func checkTaskIsCancelled(id: String) -> Bool {
        if let workItem = initialTaskContainer[id] {
            return workItem.isCancelled
        }
        if let workItem = repeatWorkContainer[id] {
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
            repeatWorkContainer.add(key: id, item: dispatchWorkItem)
            debugPrint("Task is registered ID: \(id)")
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
        debugPrint("Task is registered ID: \(id)")
    }
    
    func cancelTask(matchType: IdMatchingType, id: String) {
        switch matchType {
        case .exact:
            // WorkItem
            initialTaskContainer.cancelAndRemove(key: id)
            
            // DispatchItem
            repeatWorkContainer.cancelAndRemove(key: id)
        case .contains:
            // WorkItem
            let initialTaskKeys = initialTaskContainer.containsKey(id: id)
            if !initialTaskKeys.isEmpty {
                initialTaskContainer.cancelAndRemove(keys: initialTaskKeys)
            }
            
            // DispatchItem
            let repeatTaskIds = repeatWorkContainer.containsKey(id: id)
            if !repeatTaskIds.isEmpty {
                repeatWorkContainer.cancelAndRemove(keys: repeatTaskIds)
            }
        }
    }
    
    func cancelTasks(matchType: IdMatchingType, identifiers: [String]) {
        switch matchType {
        case .exact:
            // WorkItem
            initialTaskContainer.cancelAndRemove(keys: identifiers)
            
            // DispatchItem
            repeatWorkContainer.cancelAndRemove(keys: identifiers)
        case .contains:
            // WorkItem
            let initialTaskKeys = initialTaskContainer.containsKey(ids: identifiers)
            initialTaskContainer.cancelAndRemove(keys: initialTaskKeys)
            
            // DispatchItem
            let repeatTaskKeys = repeatWorkContainer.containsKey(ids: identifiers)
            repeatWorkContainer.cancelAndRemove(keys: repeatTaskKeys)
        }
    }
}
