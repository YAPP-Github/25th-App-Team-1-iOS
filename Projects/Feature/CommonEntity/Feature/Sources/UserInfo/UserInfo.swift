//
//  UserInfo.swift
//  FeatureCommonEntity
//
//  Created by ever on 2/13/25.
//

import Foundation

public struct UserInfo: Decodable {
    public let id: Int
    public let name: String
    public let birthDate: BirthDateData
    public let birthTime: BornTimeData
    public let gender: Gender
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case birthDate
        case birthTime
        case calendarType
        case gender
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        birthDate = try Self.decodeBirthDate(from: decoder)
        birthTime = try Self.decodeBornTime(from: decoder)
        gender = try container.decode(Gender.self, forKey: .gender)
    }
    
    static func decodeBirthDate(from decoder: Decoder) throws -> BirthDateData {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let calendarType = try container.decode(CalendarType.self, forKey: .calendarType)
        let birthDateString = try container.decode(String.self, forKey: .birthDate)
        let dateDecodingError = DecodingError.dataCorruptedError(
            forKey: .birthDate,
            in: container,
            debugDescription: "날짜 형식이 올바르지 않습니다. (yyyy-MM-dd 형식이어야 함)"
        )
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: birthDateString) else {
            throw dateDecodingError
        }
        
        let yearValue = Calendar.current.component(.year, from: date)
        let monthValue = Calendar.current.component(.month, from: date)
        let dayValue = Calendar.current.component(.day, from: date)
        
        let year = Year(yearValue)
        guard let month = Month(rawValue: monthValue),
              let day = Day(dayValue, month: month, year: year)
        else {
            throw dateDecodingError
        }
        
        return .init(calendarType: calendarType, year: year, month: month, day: day)
    }
    
    static func decodeBornTime(from decoder: Decoder) throws -> BornTimeData {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let birthTimeString = try container.decode(String.self, forKey: .birthTime)
        let dateDecodingError = DecodingError.dataCorruptedError(
            forKey: .birthDate,
            in: container,
            debugDescription: "시간 형식이 올바르지 않습니다. (HH:mm 형식이어야 함)"
        )
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        guard let time = dateFormatter.date(from: birthTimeString) else {
            throw dateDecodingError
        }
        
        var hourValue = Calendar.current.component(.hour, from: time)
        let minuteValue = Calendar.current.component(.minute, from: time)
        
        let meridiem: Meridiem = hourValue < 13 ? .am : .pm
        if meridiem == .pm {
            hourValue -= 12
        }
        guard let hour = Hour(hourValue),
              let minute = Minute(minuteValue)
        else {
            throw dateDecodingError
        }
        
        return .init(meridiem: meridiem, hour: hour, minute: minute)
    }
}
