//
//  TicketsAPI.swift
//  bait
//
//  Created by Pedro Antonio Góngora Sepúlveda on 21/04/20.
//  Copyright © 2020 Pedro Antonio Góngora Sepúlveda. All rights reserved.
//


import Foundation
import Alamofire

private enum TicketsAPI: APIConfiguration {
    case getTickets
    
    var method: HTTPMethod {
        switch self {
        case .getTickets:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getTickets:
            return "complaints?page=1"
        }
    }
    
    
    var encoding: ParameterEncoding {
        switch self {
        case .getTickets:
            return URLEncoding.default
        }
    }
        
    var parameters: Parameters? {
        switch self {
        case .getTickets:
            return nil
        }
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var urlRequest = try URLRequest(url: APIManager.shared.host + path, method: method)
        urlRequest = try encoding.encode(urlRequest, with: parameters)
        print(urlRequest)
        
        return urlRequest
    }
}

// MARK: - API Calls
extension Tickets {
        
    static func getTickets(completion: @escaping (Swift.Result<[Complaints], APIError>) -> Void) {
        
        let adapter = APIManager.shared.sessionManager.adapter as! TokenAdapter
        print(adapter.getCurrentToken())
        
        APIManager.shared.request(urlRequest: TicketsAPI.getTickets) { (result: Swift.Result<[Complaints], APIError>) in
            //result.response?.allHeaderFieldss
            switch result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    switch error {
                        case .badRequestData(let data):
                            do {
                                let decoder = JSONDecoder()
                                let errorMessage = try decoder.decode(ResponseError.self, from: data)
                                completion(.failure(.responseErrorMessage(message: errorMessage.errors[0])))
                            } catch let parsingError {
                                print(parsingError)
                            }
                        default:
                            completion(.failure(error))
                            break
                    }
            }
        }
    }
    
}
