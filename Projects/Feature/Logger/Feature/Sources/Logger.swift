//
//  Logger.swift
//  Logger
//
//  Created by choijunios on 3/12/25.
//

public protocol Logger {
    /// Must call this method on App launch
    func initialize()
    func setupUser(id: String)
}


