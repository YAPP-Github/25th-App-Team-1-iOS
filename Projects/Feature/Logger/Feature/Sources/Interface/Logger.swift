//
//  Logger.swift
//  Logger
//
//  Created by choijunios on 3/12/25.
//

public protocol Logger {
    /// Must call this method on App launch
    func initialize(autoFlushCount: Int, options: [LoggerOptions])
    func setupUser(id: String)
    func send(_ log: LogObject)
    func manualFlush()
}
