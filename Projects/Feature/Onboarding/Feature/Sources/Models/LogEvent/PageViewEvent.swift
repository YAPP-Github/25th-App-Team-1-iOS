//
//  PageViewEvent.swift
//  FeatureOnboarding
//
//  Created by choijunios on 3/17/25.
//

enum PageViewEvent {
    case intro
    case alarm
    case birthDate
    case birthTime
    case name
    case gender
    case permission
    case welcome1
    
    var eventName: String {
        switch self {
        case .intro:
            "onboarding_intro_view"
        case .alarm:
            "onboarding_alarm_view"
        case .birthDate:
            "onboarding_birthdate_view"
        case .birthTime:
            "onboarding_birthtime_view"
        case .name:
            "onboarding_name_view"
        case .gender:
            "onboarding_gender_view"
        case .permission:
            "onboarding_permission_view"
        case .welcome1:
            "onboarding_welcome1_view"
        }
    }
    
    var step: String {
        switch self {
        case .intro:
            "서비스 소개"
        case .alarm:
            "초기 알람 생성"
        case .birthDate:
            "생년월일"
        case .birthTime:
            "태어난 시간"
        case .name:
            "이름"
        case .gender:
            "성별"
        case .permission:
            "권한 설정1"
        case .welcome1:
            "환영1"
        }
    }
}
