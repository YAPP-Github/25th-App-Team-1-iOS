//
//  PageViewDurationLogBuilder.swift
//  Fortune
//
//  Created by choijunios on 3/18/25.
//

import Foundation

import FeatureLogger

final class PageViewDurationLogBuilder: LogObjectBuilder {
    
    init(eventType: FortunePageViewEvent, start: Date, end: Date) {
        super.init(eventType: eventType.eventName)
        let seconds = Double(Int(end.timeIntervalSince(start) * 100)) / 100
        setProperty(key: "duration", value: seconds)
    }
}
