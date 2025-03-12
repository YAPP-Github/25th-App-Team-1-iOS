//
//  DefaultLogger.swift
//  Logger
//
//  Created by choijunios on 3/12/25.
//

import UIKit

import Mixpanel

public final class DefaultLogger: Logger {
    // State
    private let counter = EventCounter()
    private var autoFlushCount: Int?
    private var options: [LoggerOptions] = []
    private var isReady: Bool {
        autoFlushCount != nil &&
        Mixpanel.mainInstance().loggingEnabled
    }
    
    public init() { }
    
    private func handleOptions(_ options: [LoggerOptions]) {
        self.options = options
        options.forEach { option in
            switch option {
            case .flushOnEnterBackground:
                subscribeToEnterBackground()
            }
        }
    }
    
    private func subscribeToEnterBackground() {
        let enterBackgroundEvent = UIApplication.didEnterBackgroundNotification
        NotificationCenter.default.removeObserver(
            self,
            name: enterBackgroundEvent,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onBackground(_:)),
            name: enterBackgroundEvent,
            object: nil
        )
    }
    @objc func onBackground(_ notification: Notification) {
        manualFlush()
    }
}


// MARK: Logger
public extension DefaultLogger {
    func initialize(autoFlushCount: Int, options: [LoggerOptions]=[]) {
        Mixpanel.initialize(
            token: "",
            trackAutomaticEvents: false
        )
        Mixpanel.mainInstance().loggingEnabled = true
        handleOptions(options)
    }
    
    func setupUser(id: String) {
        Mixpanel.mainInstance().userId = id
    }
    
    func send(_ log: LogObject) {
        Task {
            guard isReady == true else { return }
            await counter.countUp()
            Mixpanel.mainInstance().track(
                event: log.eventType,
                properties: {
                    var properties: [String: MixpanelType] = [:]
                    for property in log.properties {
                        if let mixpanelValue = property.value as? MixpanelType {
                            properties[property.key] = mixpanelValue
                        }
                    }
                    return properties
                }()
            )
            
            // Check flushable
            if await counter.getCount() >= autoFlushCount! {
                Mixpanel.mainInstance().flush()
                await counter.clear()
            }
        }
    }
    
    func manualFlush() {
        Task {
            Mixpanel.mainInstance().flush()
            await counter.clear()
        }
    }
}
