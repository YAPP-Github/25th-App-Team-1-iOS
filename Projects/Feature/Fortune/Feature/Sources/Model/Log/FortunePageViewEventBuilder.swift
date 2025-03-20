//
//  FortunePageViewEventBuilder.swift
//  Fortune
//
//  Created by choijunios on 3/17/25.
//

import FeatureLogger

final class FortunePageViewEventBuilder: LogObjectBuilder {
    
    init(eventType: FortunePageViewEvent) {
        super.init(eventType: eventType.eventName)
        setProperty(key: "page_number", value: eventType.pageNumber)
    }
}
