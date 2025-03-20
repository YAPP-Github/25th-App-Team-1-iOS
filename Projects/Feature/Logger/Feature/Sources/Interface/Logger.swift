//
//  Logger.swift
//  Logger
//
//  Created by choijunios on 3/12/25.
//

public protocol Logger {
    func setupUser(id: String)
    func send(_ object: LogObject)
    func manualFlush()
}
