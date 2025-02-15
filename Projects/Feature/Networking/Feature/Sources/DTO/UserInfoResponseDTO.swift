//
//  UserInfoResponseDTO.swift
//  FeatureNetworking
//
//  Created by choijunios on 2/14/25.
//

import FeatureCommonDependencies

public struct UserInfoResponseDTO: Codable {
    public let id: Int
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

public extension UserInfoResponseDTO {
    func toUserInfo() -> UserInfo {
        let birthdateList = birthDate.split(separator: "-")
        let calendarType: CalendarType = calendarType == .lunar ? .lunar : .gregorian
        let year = Year(Int(birthdateList[0])!)
        let month = Month(rawValue: Int(birthdateList[1])!)!
        let day = Day(
            Int(birthdateList[2])!,
            calendar: calendarType,
            month: month,
            year: year
        )!
        
        var bornTimeData: BornTimeData?
        if let bornTime = birthTime {
            let bornTimeList = bornTime.split(separator: ":")
            let hour = Int(bornTimeList[0])!
            let minute = Int(bornTimeList[1])!
            
            let meridiemEntity: Meridiem = hour >= 12 ? .pm : .am
            var hourEntity: Hour!
            if meridiemEntity == .pm {
                if (hour-12) == 0 {
                    hourEntity = .init(hour)!
                } else {
                    hourEntity = .init(hour-12)!
                }
            } else {
                hourEntity = .init(hour)!
            }
            let minuteEntity: Minute = .init(minute)!
            bornTimeData = .init(
                meridiem: meridiemEntity,
                hour: hourEntity,
                minute: minuteEntity
            )
        }
        return UserInfo(
            id: id,
            name: name,
            birthDate: .init(
                calendarType: calendarType,
                year: year,
                month: month,
                day: day
            ),
            birthTime: bornTimeData,
            gender: gender == .male ? .male : .female
        )
    }
}
