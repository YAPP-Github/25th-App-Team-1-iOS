//
//  Preference.swift
//  FeatureCommonEntity
//
//  Created by ever on 2/7/25.
//

import Foundation

@propertyWrapper
public struct UserDefault<T> {
    public let key: String
    public let defaultValue: T
    private let userDefaults = UserDefaults.standard

    public var wrappedValue: T {
        get { userDefaults.object(forKey: key) as? T ?? defaultValue }
        set { userDefaults.set(newValue, forKey: key) }
    }
}

public struct Preference {
    @UserDefault(key: "isOnboardingFinished", defaultValue: false)
    public static var isOnboardingFinished: Bool
    
    @UserDefault(key: "userId", defaultValue: nil)
    public static var userId: Int?
}
