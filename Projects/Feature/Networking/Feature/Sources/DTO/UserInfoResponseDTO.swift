//
//  UserInfoResponseDTO.swift
//  FeatureNetworking
//
//  Created by choijunios on 2/14/25.
//

import Foundation

public struct UserInfoResponseDTO: Codable {
    public let name: String
    public let birthDate: String
    public let birthTime: String?
    public let gender: GenderDTO
    public let calendarType: CalendarTypeDTO
}

public enum GenderDTO: String, Codable {
    case male = "MALE"
    case female = "FEMALE"
}

public enum CalendarTypeDTO: String, Codable {
    case solar = "SOLAR"
    case lunar = "LUNAR"
}
