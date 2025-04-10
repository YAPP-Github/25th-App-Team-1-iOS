//
//  AmplitudeEventLogger.swift
//  Logger
//
//  Created by choijunios on 3/12/25.
//

import UIKit

import AmplitudeSwift

public final class AmplitudeEventLogger: Logger {
    // Dependency
    private let amplitude: Amplitude
    
    public init() {
        let apiKey = APIKeys.aplitude
        let config = Configuration(
            apiKey: apiKey,
            flushIntervalMillis: 10 * 1000, // 10s
            flushEventsOnClose: true
        )
        amplitude = .init(configuration: config)
    }
}


// MARK: Logger
public extension AmplitudeEventLogger {
    func setupUser(id: String) {
        amplitude.setUserId(userId: "ORBIT_\(id)")
    }
    
    func send(_ object: LogObject) {
        let eventType = object.eventType
        let eventProperties = object.properties
        amplitude.track(
            eventType: eventType,
            eventProperties: eventProperties
        )
    }
    
    func manualFlush() {
        amplitude.flush()
    }
}
