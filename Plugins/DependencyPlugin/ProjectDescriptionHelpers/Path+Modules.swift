import Foundation
import ProjectDescription

// MARK: ProjectDescription.Path + App

public extension ProjectDescription.Path {
    
    static var app: Self {
        
        return .relativeToRoot("Projects/\(ModulePath.App.categoryName)")
    }
    
}


// MARK: ProjectDescription.Path + Feature

public extension ProjectDescription.Path {
    
    /// Feature모듈들이 존재하는 경로를 반환합니다.
    static var feature: Self {
        
        return .relativeToRoot("Projects/\(ModulePath.Feature.categoryName)")
    }
    
    
    /// 특정 Feature모듈의 경로를 반환합니다.
    static func feature(implementation module: ModulePath.Feature) -> Self {
        
        return .relativeToRoot("Projects/\(ModulePath.Feature.categoryName)/\(module.rawValue)")
    }
}
