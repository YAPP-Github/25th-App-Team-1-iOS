//
//  LogObjectBuilder.swift
//  Logger
//
//  Created by choijunios on 3/12/25.
//

// MARK: LogObjectBuilder
open class LogObjectBuilder {
    public let eventType: String
    public private(set) var properties: [String: Any] = [:]
    
    public init(eventType: String) {
        self.eventType = eventType
    }
    
    @discardableResult
    public func setProperty(key: String, value: Any) -> Self {
        self.properties[key] = value
        return self
    }
    
    open func build() -> LogObject {
        LogObject(
            eventType: eventType,
            properties: properties
        )
    }
}
