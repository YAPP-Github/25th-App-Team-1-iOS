//
//  AlarmManagerError.swift
//  FeatureAlarmController
//
//  Created by choijunios on 3/6/25.
//

public enum AlarmControllerError: Error {
    case dataSavingError
    case dataFetchError
    case alarmRegisterError
    
    public var message: String {
        switch self {
        case .dataSavingError:
            "알람을 저장하는 과정에서 문제가 발생했습니다."
        case .dataFetchError:
            "알람을 불러오는 과정에서 문제가 발생했습니다."
        case .alarmRegisterError:
            "알람을 등록하는 과정에서 문제가 발생했습니다."
        }
    }
}
