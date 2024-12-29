import Foundation
import ProjectDescription


// MARK: TargetDependency + App

public extension TargetDependency {
    
    static var app: Self {
        
        return .project(target: ModulePath.App.categoryName, path: .app)
    }
    
    
    static func app(implements module: ModulePath.App) -> Self {
        
        return .target(name: ModulePath.App.categoryName + module.rawValue)
    }
    
}


// MARK: TargetDependency + Feature

public extension TargetDependency {
    
    static var feature: Self {
        
        return .project(target: ModulePath.Feature.categoryName, path: .feature)
    }
    
    
    static func feature(implements module: ModulePath.Feature) -> Self {
        
        return .project(
            target: ModulePath.Feature.categoryName + module.rawValue,
            path: .feature(implementation: module)
        )
    }
    

    static func feature(tests module: ModulePath.Feature) -> Self {
        
        return .project(
            target: ModulePath.Feature.categoryName + module.rawValue + "Tests",
            path: .feature(implementation: module)
        )
    }
}


// MARK: TargetDependency + ThirdParty

public extension TargetDependency {
    
    static func thirdParty(library module: ModulePath.ThirdParty) -> Self {
        
        return .external(name: module.rawValue, condition: nil)
    }
}
