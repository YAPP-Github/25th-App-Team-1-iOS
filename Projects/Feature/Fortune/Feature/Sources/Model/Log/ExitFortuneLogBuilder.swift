//
//  ExitFortuneLogBuilder.swift
//  Fortune
//
//  Created by choijunios on 3/17/25.
//

import FeatureLogger

final class ExitFortuneLogBuilder: LogObjectBuilder {
    init(pageNumber: Int) {
        super.init(eventType: "fortune_exit")
        setProperty(key: "fortune_page_number", value: pageNumber)
    }
}
