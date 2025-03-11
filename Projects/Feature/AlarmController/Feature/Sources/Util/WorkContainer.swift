//
//  WorkContainer.swift
//  AlarmController
//
//  Created by choijunios on 3/10/25.
//

import Foundation

protocol WorkCancellable {
    func cancel()
}
extension DispatchWorkItem: WorkCancellable { }

class WorkContainer<T: WorkCancellable> {
    private var items: [String: T] = [:]
    private let itemLock = NSLock()
    
    subscript (key: String) -> T? {
        itemLock.lock()
        defer { itemLock.unlock() }
        return items[key]
    }
    
    func containsKey(id checking: String) -> [String] {
        itemLock.lock()
        defer { itemLock.unlock() }
        return items.keys.filter { id in id.contains(checking) }
    }
    
    func containsKey(ids checkings: [String]) -> [String] {
        itemLock.lock()
        defer { itemLock.unlock() }
        return items.keys.filter { id in
            for check in checkings {
                if id.contains(check) { return true }
            }
            return false
        }
    }
    
    func cancelAndRemove(key: String) {
        itemLock.lock()
        defer { itemLock.unlock() }
        guard let item = items[key] else { return }
        debugPrint("\(Self.self), Task cancelled & removed \(key)")
        item.cancel()
        items.removeValue(forKey: key)
    }
    
    func cancelAndRemove(keys: [String]) {
        itemLock.lock()
        defer { itemLock.unlock() }
        keys.forEach { key in
            guard let item = items[key] else { return }
            debugPrint("\(Self.self), Task cancelled & removed \(key)")
            item.cancel()
            items.removeValue(forKey: key)
        }
    }
    
    func add(key: String, item: T) {
        itemLock.lock()
        defer { itemLock.unlock() }
        items[key] = item
    }
    
    func getValues() -> [T] {
        itemLock.lock()
        defer { itemLock.unlock() }
        return items.values.map{$0}
    }
    
    func getKeys() -> [String] {
        itemLock.lock()
        defer { itemLock.unlock() }
        return items.keys.map{$0}
    }
}
