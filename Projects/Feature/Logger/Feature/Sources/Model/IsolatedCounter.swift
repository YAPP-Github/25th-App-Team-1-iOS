//
//  IsolatedCounter.swift
//  Logger
//
//  Created by choijunios on 3/12/25.
//

actor IsolatedCounter {
    private var count: Int = 0
    
    func countUp() {
        count += 1
    }
    
    func clear() {
        count = 0
    }
    
    func getCount() -> Int {
        return count
    }
}
