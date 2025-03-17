//
//  PageViewLogBuilder.swift
//  FeatureOnboarding
//
//  Created by choijunios on 3/17/25.
//

import FeatureLogger

class PageViewLogBuilder: LogObjectBuilder {
    init(event: PageViewEvent) {
        super.init(eventType: event.eventName)
        setProperty(key: "step", value: event.step)
    }
}
