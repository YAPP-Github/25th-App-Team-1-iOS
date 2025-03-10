//
//  WorkItem.swift
//  AlarmController
//
//  Created by choijunios on 3/10/25.
//

import Foundation

class WorkItem {
    let id: String
    let date: Date
    let task: () -> Void
    public private(set) var isCancelled = false
    
    init(id: String, date: Date, task: @escaping () -> Void) {
        self.id = id
        self.date = date
        self.task = task
    }
    
    func cancel() { isCancelled = true }
}
