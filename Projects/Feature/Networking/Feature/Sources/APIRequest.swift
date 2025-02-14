//
//  APIRequest.swift
//  ProjectDescriptionHelpers
//
//

import Foundation
import Alamofire
import RxSwift

enum ContentType: String {
    case json = "application/json"
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
}

public protocol APIRequestProtocol: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var encoding: ParameterEncoding { get }
    var parameters: Parameters? { get }
}

public extension APIRequestProtocol {
    func asURLRequest() throws -> URLRequest {
        let url = APIConstants.baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.method = method
        
        // Common Headers
        if encoding is JSONEncoding {
            urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        }
        
        // Parameters
        if let parameters = parameters {
            return try encoding.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}

public enum APIRequest {}
