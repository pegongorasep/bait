//
//  APIManager.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//

import Foundation
import Alamofire

public protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var encoding: ParameterEncoding { get }
    var parameters: Parameters? { get }
    var jsonDecoder: JSONDecoder { get }
}

public extension APIConfiguration {
    var jsonDecoder: JSONDecoder {
        get {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .useDefaultKeys
            return jsonDecoder
        }
    }
}

public enum APIError: Error {
    case jsonDecodingError
    case serverError(error: String)
    case badRequestData(data: Data)
    case responseErrorMessage(message: String)
}

public class APIManager {
    static public let shared = APIManager()
    public var host = "https://api-bait.herokuapp.com/api/v1/"
    public let sessionManager = Alamofire.SessionManager.default

    private init() {}

    public func request<T: Codable>(urlRequest: APIConfiguration, completion: @escaping (Swift.Result<T, APIError> ) -> Void) {
        sessionManager.request(urlRequest)
            .validate()
            .responseData { (response) in
                
                switch response.result {
                    
                    
                case .success(let value):
                    guard value.count > 0 else {
                        if let emptyJson = "{}".data(using: .utf8), let decodedObject = try? urlRequest.jsonDecoder.decode(T.self, from: emptyJson) {
                            completion(.success(decodedObject))
                        }
                        return
                    }
                    do {
                        let decodedObject = try urlRequest.jsonDecoder.decode(T.self, from: value)
                        
                        if let headers = response.response?.allHeaderFields as? [String: String]{
                            let token = headers["Authorization"]
                            if let _ = decodedObject as? User {
                                var user = decodedObject as? User
                                user?.token = token
                                completion(.success(user as! T))
                            } else {
                                completion(.success(decodedObject))
                            }
                        }
                        
                        completion(.success(decodedObject))
                        
                    } catch {
                        print(error)
                        completion(.failure(APIError.jsonDecodingError))
                    }
                    
                    
                case .failure(let error):
                    completion(.failure(.serverError(error: error.localizedDescription)))
                }
        }
    }
}
