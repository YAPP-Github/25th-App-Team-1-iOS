import ProjectDescription

public extension InfoPlist {
    
    static let app: InfoPlist = .app_plist(with: [:])
    
    static let example_app: InfoPlist = .app_plist(with: [:])
    
    static let resources: InfoPlist = .app_plist(with: [
        "UIAppFonts": .array([
            "Pretendard-Black.otf",
            "Pretendard-Bold.otf",
            "Pretendard-ExtraBold.otf",
            "Pretendard-ExtraLight.otf",
            "Pretendard-Light.otf",
            "Pretendard-Medium.otf",
            "Pretendard-Regular.otf",
            "Pretendard-SemiBold.otf",
            "Pretendard-Thin.otf",
        ])
    ])
}

extension InfoPlist {
    
    private static let app_plist: [String: ProjectDescription.Plist.Value] = [
        
        "NSAppTransportSecurity" : [
            "NSAllowsArbitraryLoads" : true
        ],
        "UILaunchStoryboardName": "LaunchScreen.storyboard",
        "CFBundleDisplayName" : "$(BUNDLE_DISPLAY_NAME)",
        
        
        // ※ SceneDelegate 사용시 아래 코드 활성화
        
//        "UIApplicationSceneManifest": [
//            "UIApplicationSupportsMultipleScenes": false,
//            "UISceneConfigurations": [
//                "UIWindowSceneSessionRoleApplication": [
//                    [
//                        "UISceneConfigurationName": "Default Configuration"
//                    ]
//                ]
//            ]
//        ],
    ]
    
    public static func app_plist(with: [String: ProjectDescription.Plist.Value]) -> InfoPlist {
        
        var resultPlist = app_plist
        
        resultPlist.merge(with) { lhs, rhs in rhs }
        
        return .extendingDefault(with: resultPlist)
    }
}

