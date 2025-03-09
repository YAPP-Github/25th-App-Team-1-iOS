//
//  BackgoundTaskScheduler.swift
//  FeatureAlarmController
//
//  Created by choijunios on 3/8/25.
//

import Foundation

public enum TaskExecutionType {
    case once
    case repeats(intervalSeconds: Int, count: TaskExecutionCount)
}

public enum TaskExecutionCount {
    case limit(count: Int)
    case forever
}

public protocol BackgoundTaskScheduler {
    func register(id: String, startDate: Date, type: TaskExecutionType, task: @escaping (Int) -> Void)
    func cancelTask(id: String)
    func cancelTasks(identifiers: [String])
}
