//
//  MissionActionEvent.swift
//  AlarmMission
//
//  Created by choijunios on 3/17/25.
//

enum MissionActionEvent {
    case missionStart
    case skipMission
    case missionComplete
    case missionFailure
    
    var eventName: String {
        switch self {
        case .missionStart:
            "mission_ready_start"
        case .skipMission:
            "mission_ready_skip"
        case .missionComplete:
            "mission_success"
        case .missionFailure:
            "mission_fail"
        }
    }
}
