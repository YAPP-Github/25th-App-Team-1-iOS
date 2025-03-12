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
    private let trackedEventCounter = IsolatedCounter()
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
            case .flushOnTermination:
                subscribeToAppTermination()
            }
        }
    }
    
    private func subscribeToAppTermination() {
        let terminationEvent = UIApplication.willTerminateNotification
        NotificationCenter.default.removeObserver(
            self,
            name: terminationEvent,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onNotification(_:)),
            name: terminationEvent,
            object: nil
        )
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
            selector: #selector(onNotification(_:)),
            name: enterBackgroundEvent,
            object: nil
        )
    }
    @objc func onNotification(_ notification: Notification) {
        switch notification.name {
        case UIApplication.didEnterBackgroundNotification, UIApplication.willTerminateNotification:
            manualFlush()
        default:
            break
        }
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
            await trackedEventCounter.countUp()
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
            if await trackedEventCounter.getCount() >= autoFlushCount! {
                Mixpanel.mainInstance().flush()
                await trackedEventCounter.clear()
            }
        }
    }
    
    func manualFlush() {
        Task {
            Mixpanel.mainInstance().flush(performFullFlush: true)
            await trackedEventCounter.clear()
        }
    }
}
