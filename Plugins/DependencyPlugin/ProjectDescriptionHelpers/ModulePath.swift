
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
        case Resources
        case DesignSystem
        
        public static let categoryName: String = "Feature"

    }
    
}


// MARK: Third party

public extension ModulePath {
    
    enum ThirdParty: String, CaseIterable {
        
        case RIBs
        case Then
        case SnapKit
        
        public static let categoryName: String = "ThirdParty"
    }
}
