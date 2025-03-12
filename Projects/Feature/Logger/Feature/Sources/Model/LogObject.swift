//
//  LogObject.swift
//  Logger
//
//  Created by choijunios on 3/12/25.
//

open class LogObject {
    public let eventType: String
    public let properties: [String: Any]
    
    public init(eventType: String, properties: [String: Any] = [:]) {
        self.eventType = eventType
        self.properties = properties
    }
}


public extension LogObject {
    var description: String {
        """
        ==================================================
        [이벤트 타입] : \(eventType)
        [매개 변수]
        \(properties)
        ==================================================
        """
    }
}
