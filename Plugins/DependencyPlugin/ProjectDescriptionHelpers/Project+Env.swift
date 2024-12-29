import Foundation
import ProjectDescription


public extension Project {
    
    enum Environment {
        
        public static let appName: String = "Orbit"
        public static let deploymentTarget: DeploymentTargets = .iOS("17.0")
        
        private static let bundlePrefix: String = "com.yaf.orbit"
        public static func bundleId(suffix: String) -> String {
            
            return "\(bundlePrefix).\(suffix)"
        }
    }
}

