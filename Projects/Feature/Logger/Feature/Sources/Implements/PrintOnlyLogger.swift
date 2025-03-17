//
//  PrintOnlyLogger.swift
//  Logger
//
//  Created by choijunios on 3/17/25.
//

public final class PrintOnlyLogger: Logger {
    
    public init() { }
    
    public func setupUser(id: String) {
        print("\(#function) \(id)")
    }
    
    public func send(_ object: LogObject) {
        print("\(#function)\n\(object.description)")
    }
    
    public func manualFlush() {
        print("\(#function)")
    }
}
