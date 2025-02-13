//
//  APIClient.swift
//  FeatureNetworking
//
//  Created by ever on 2/13/25.
//

import Alamofire

public class APIClient {
    
    public typealias onSuccess<T> = ((T) -> Void)
    public typealias onFailure = ((_ error: Error) -> Void)
    
    public static func request<T>(_ object: T.Type,
                                  request: APIRequestProtocol,
                                  success: @escaping onSuccess<T>,
                                  failure: @escaping onFailure) where T: Decodable {
        AF.request(request)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success:
                    guard let decodedData = response.value else { return }
                    success(decodedData)
                case .failure(let err):
                    failure(err)
                }
            }
    }
    
}
