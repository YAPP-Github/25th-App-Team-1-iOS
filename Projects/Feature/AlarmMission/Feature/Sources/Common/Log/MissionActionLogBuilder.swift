//
//  MissionActionLogBuilder.swift
//  AlarmMission
//
//  Created by choijunios on 3/17/25.
//

import FeatureLogger

final class MissionActionLogBuilder: LogObjectBuilder {
    
    init(eventType: MissionActionEvent, mission: AlarmMissionType) {
        super.init(eventType: eventType.eventName)
        setProperty(key: "mission_type", value: mission.logPropertyValue)
    }
}
