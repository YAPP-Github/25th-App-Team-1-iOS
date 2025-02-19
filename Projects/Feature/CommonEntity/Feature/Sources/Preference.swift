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

@propertyWrapper
public struct CodableUserDefault<T: Codable> {
    public let key: String
    private let userDefaults = UserDefaults.standard

    public var wrappedValue: T? {
        get {
            guard let data = userDefaults.data(forKey: key) else { return nil }
            let decoded = try? JSONDecoder().decode(T.self, from: data)
            return decoded
        }
        set {
            guard let newValue, let encoded = try? JSONEncoder().encode(newValue) else { return }
            userDefaults.set(encoded, forKey: key)
        }
    }
}


public struct Preference {
    @UserDefault(key: "isOnboardingFinished", defaultValue: false)
    public static var isOnboardingFinished: Bool
    
    @UserDefault(key: "userId", defaultValue: nil)
    public static var userId: Int?
    
    @CodableUserDefault(key: "userName")
    public static var userInfo: UserInfo?
}
