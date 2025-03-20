//
//  PageViewDurationLogBuilder.swift
//  Fortune
//
//  Created by choijunios on 3/18/25.
//

import Foundation

import FeatureLogger

final class PageViewDurationLogBuilder: LogObjectBuilder {
    
    init(pageNumber: Int, start: Date, end: Date) {
        super.init(eventType: "fortune_time_spent")
        let seconds = Double(Int(end.timeIntervalSince(start) * 100)) / 100
        setProperty(key: "fortune_page_number", value: pageNumber)
        setProperty(key: "duration", value: seconds)
    }
}
