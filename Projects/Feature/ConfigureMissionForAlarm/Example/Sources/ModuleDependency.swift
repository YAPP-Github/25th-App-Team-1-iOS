//
//  ModuleDependency.swift
//  ConfigureMissionForAlarm
//
//  Created by choijunios on 7/22/25.
//

import FeatureConfigureMissionForAlarm
import FeatureLogger

class ModuleDependency: ConfigureMissionForAlarmDependency {
    var logger: FeatureLogger.Logger
    
    init(logger: FeatureLogger.Logger) {
        self.logger = logger
    }
}

