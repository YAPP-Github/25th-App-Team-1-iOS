
// Created by choijunyeong

import Foundation
import ProjectDescription

public enum ModulePath {
    
    case feature(Feature)
}


// MARK: App module

public extension ModulePath {
    
    enum App: String, CaseIterable {
        
        case iOS
        
        public static let categoryName = "App"
        
    }
    
}


// MARK: Feature module

public extension ModulePath {
    
    enum Feature: String, CaseIterable {
        
        case Root
        case Onboarding
        case Alarm
        case AlarmCommon
        case AlarmController
        
        case UIDependencies
        case Resources
        case DesignSystem
        
        case CommonDependencies
        case CommonEntity
        
        case ThirdPartyDependencies
        
        case AlarmMission
        case AlarmRelease
        case Main
        case Fortune
        case Setting
        
        case Networking
        
        case Logger
        
        public static let categoryName: String = "Feature"

    }
    
}


// MARK: Third party

public extension ModulePath {
    
    enum ThirdParty: String, CaseIterable {
        case RIBs
        case Then
        case SnapKit
        case Lottie
        case Alamofire
        case Mixpanel
        
        public static let categoryName: String = "ThirdParty"
    }
}
