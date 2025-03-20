//
//  PageActionBuilder.swift
//  FeatureOnboarding
//
//  Created by choijunios on 3/17/25.
//

import FeatureLogger

class PageActionBuilder: LogObjectBuilder {
    init(event: PageActionEvent) {
        super.init(eventType: event.eventName)
    }
}
