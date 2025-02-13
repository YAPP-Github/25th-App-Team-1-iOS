//
//  APIRequest+Users.swift
//  FeatureNetworking
//
//  Created by ever on 2/13/25.
//

import Alamofire

public extension APIRequest {
    enum Users: APIRequestProtocol {
        case addUser(name: String, birthDate: String, birthTime: String, gender: String, calendarType: String)
        case getUser(userId: Int)
        public var method: HTTPMethod {
            switch self {
            case .getUser:
                return .get
            case .addUser:
                return .post
            }
        }
        
        public var path: String {
            switch self {
            case .addUser:
                return "users"
            case .getUser(let userId):
                return "users/\(userId)"
            }
        }
        
        public var parameters: Parameters? {
            switch self {
            case let .addUser(name, birthDate, birthTime, gender, calendarType):
                let parameter = [
                    "name": name,
                    "birthDate": birthDate,
                    "birthTime": birthTime,
                    "gender": gender,
                    "calendarType": calendarType
                ]
                print(parameter)
                return parameter
            default: return nil
            }
        }
        
        public var encoding: ParameterEncoding {
            return JSONEncoding.default
        }
    }
}
