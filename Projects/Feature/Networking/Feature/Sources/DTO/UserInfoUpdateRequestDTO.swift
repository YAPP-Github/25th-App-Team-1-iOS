//
//  UserInfoUpdateRequestDTO.swift
//  FeatureNetworking
//
//  Created by choijunios on 2/14/25.
//

public struct UserInfoUpdateRequestDTO: Encodable, Sendable {
    public var name: String?
    public var birthDate: String?
    public var birthTime: String?
    public var gender: String?
    public var calendarType: String?
    
    public init(name: String? = nil, birthDate: String? = nil, birthTime: String? = nil, gender: String? = nil, calendarType: String? = nil) {
        self.name = name
        self.birthDate = birthDate
        self.birthTime = birthTime
        self.gender = gender
        self.calendarType = calendarType
    }
}
