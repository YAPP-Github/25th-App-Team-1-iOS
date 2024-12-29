
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
        case Alarm
        
        public static let categoryName: String = "Feature"

    }
    
}


// MARK: Third party

public extension ModulePath {
    
    enum ThirdParty: String, CaseIterable {
        
        case RIBs
        
        public static let categoryName: String = "ThirdParty"
    }
}
