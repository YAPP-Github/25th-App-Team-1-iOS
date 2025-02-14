//
//  APIRequest+Fortune.swift
//  FeatureNetworking
//
//  Created by ever on 2/14/25.
//

import Alamofire

public extension APIRequest {
    enum Fortune: APIRequestProtocol {
        case createFortune(userId: Int)
        case getFortune(fortuneId: Int)

        public var method: HTTPMethod {
            switch self {
            case .createFortune:
                return .post
            case .getFortune:
                return .get
            }
        }
        
        public var path: String {
            switch self {
            case .createFortune:
                return "fortunes"
            case let .getFortune(fortuneId):
                return "fortunes/\(fortuneId)"
            }
        }
        
        public var parameters: Parameters? {
            switch self {
            case let .createFortune(userId):
                return ["userId": userId]
            case .getFortune:
                return nil
            }
        }
        
        public var encoding: ParameterEncoding {
            return URLEncoding.default
        }
    }
}
