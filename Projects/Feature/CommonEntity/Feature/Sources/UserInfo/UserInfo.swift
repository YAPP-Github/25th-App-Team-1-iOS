//
//  UserInfo.swift
//  FeatureCommonEntity
//
//  Created by ever on 2/13/25.
//

import Foundation

public struct UserInfo: Codable, Equatable {
    public let id: Int
    public var name: String
    public var birthDate: BirthDateData
    public var birthTime: BornTimeData?
    public var gender: Gender
    
    public init(id: Int, name: String, birthDate: BirthDateData, birthTime: BornTimeData? = nil, gender: Gender) {
        self.id = id
        self.name = name
        self.birthDate = birthDate
        self.birthTime = birthTime
        self.gender = gender
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try Self.encodeBirthDate(birthDate, to: &container)
        try Self.encodeBornTime(birthTime, to: &container)
        try container.encode(gender, forKey: .gender)
    }
    
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
        
        let calendar = Calendar(identifier: calendarType.calendarIdentifier)
        let yearValue = calendar.component(.year, from: date)
        let monthValue = calendar.component(.month, from: date)
        let dayValue = calendar.component(.day, from: date)
        
        let year = Year(yearValue)
        guard let month = Month(rawValue: monthValue),
              let day = Day(dayValue, calendar: calendarType, month: month, year: year)
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
        
        let meridiem: Meridiem = hourValue < 12 ? .am : .pm
        if hourValue >= 13 {
            hourValue -= 12
        }
        if hourValue == 0 {
            hourValue += 12
        }
        guard let hour = Hour(hourValue),
              let minute = Minute(minuteValue)
        else {
            throw dateDecodingError
        }
        
        return .init(meridiem: meridiem, hour: hour, minute: minute)
    }
}


extension UserInfo {
    static func encodeBirthDate(_ birthDate: BirthDateData, to container: inout KeyedEncodingContainer<CodingKeys>) throws {
        try container.encode(birthDate.calendarType, forKey: .calendarType)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateComponents = DateComponents(
            calendar: Calendar(identifier: birthDate.calendarType.calendarIdentifier),
            year: birthDate.year.value,
            month: birthDate.month.rawValue,
            day: birthDate.day.value
        )
        
        guard let date = dateComponents.date else {
            throw EncodingError.invalidValue(
                birthDate,
                EncodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "날짜 변환에 실패했습니다."
                )
            )
        }
        
        let birthDateString = dateFormatter.string(from: date)
        try container.encode(birthDateString, forKey: .birthDate)
    }
    
    static func encodeBornTime(_ birthTime: BornTimeData?, to container: inout KeyedEncodingContainer<CodingKeys>) throws {
        guard let birthTime = birthTime else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        var hour = birthTime.hour.value
        if birthTime.meridiem == .pm {
            hour += 12
        }
        
        let dateComponents = DateComponents(
            hour: hour,
            minute: birthTime.minute.value
        )
        
        guard let time = Calendar.current.date(from: dateComponents) else {
            throw EncodingError.invalidValue(
                birthTime,
                EncodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "시간 변환에 실패했습니다."
                )
            )
        }
        
        let birthTimeString = dateFormatter.string(from: time)
        try container.encode(birthTimeString, forKey: .birthTime)
    }
}
