//
//  APIRequest+Users.swift
//  FeatureNetworking
//
//  Created by ever on 2/13/25.
//

import Alamofire

import Foundation

public extension APIRequest {
    enum Users: APIRequestProtocol {
        case addUser(name: String, birthDate: String, birthTime: String?, gender: String, calendarType: String)
        case getUser(userId: Int)
        case updateUser(userId: Int, updateInfo: UserInfoUpdateRequestDTO)
        public var method: HTTPMethod {
            switch self {
            case .getUser:
                return .get
            case .addUser:
                return .post
            case .updateUser:
                return .put
            }
        }
        
        public var path: String {
            switch self {
            case .addUser:
                return "users"
            case .getUser(let userId):
                return "users/\(userId)"
            case .updateUser(let userId, _):
                return "users/\(userId)"
            }
        }
        
        public var parameters: Parameters? {
            switch self {
            case let .addUser(name, birthDate, birthTime, gender, calendarType):
                return [
                    "name": name,
                    "birthDate": birthDate,
                    "birthTime": birthTime,
                    "gender": gender,
                    "calendarType": calendarType
                ]
            case .updateUser(_, let updateInfo):
                do {
                    let encoded = try JSONEncoder().encode(updateInfo)
                    let jsonObject = try JSONSerialization.jsonObject(with: encoded) as? [String: String]
                    return jsonObject
                } catch {
                    debugPrint("유저 업데이트 DTO인코딩 실패")
                    return nil
                }
            default: return nil
            }
        }
        
        public var encoding: ParameterEncoding {
            return JSONEncoding.default
        }
    }
}
