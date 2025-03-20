//
//  PageActionEvent.swift
//  FeatureOnboarding
//
//  Created by choijunios on 3/17/25.
//

import FeatureCommonEntity

enum PageActionEvent {
    case introNext
    case alarmCreate
    case birthDateNext
    case birthTimeNext
    case birthTimeUnknown
    case nameNext
    case genderSelect
    case permissionSelect
    case complete
    
    var eventName: String {
        switch self {
        case .introNext:
            "onboarding_intro_next"
        case .alarmCreate:
            "onboarding_alarm_create"
        case .birthDateNext:
            "onboarding_birthdate_next"
        case .birthTimeNext:
            "onboarding_birthtime_next"
        case .birthTimeUnknown:
            "onboarding_birthtime_unknown"
        case .nameNext:
            "onboarding_name_next"
        case .genderSelect:
            "onboarding_gender_select"
        case .permissionSelect:
            "onboarding_permission_request"
        case .complete:
            "onboarding_complete"
        }
    }
}
