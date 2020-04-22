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
    case createTicket(parameters: Parameters)
    
    var method: HTTPMethod {
        switch self {
        case .getTickets:
            return .get
        case .createTicket:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getTickets:
            return "complaints?page=1"
        case .createTicket:
            return "complaints"
        }
    }
    
    
    var encoding: ParameterEncoding {
        switch self {
            case .getTickets, .createTicket:
                return URLEncoding.default
        }
    }
        
    var parameters: Parameters? {
        switch self {
            case .getTickets:
                return nil
            case .createTicket(let parameters):
                return parameters
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
        
    static func createTicket(title: String, description: String, condominium_id: String, user_id: String, image: String, completion: @escaping (Swift.Result<Tickets, APIError>) -> Void) {
        
        let parameters: Parameters = [
            "title": title,
            "description": description,
            "condominium_id": condominium_id,
            "user_id":  user_id,
            "complaint_state_id": 3,
            "file_count": 0,
            "file[0]": 0,
        ]
        
        APIManager.shared.request(urlRequest: TicketsAPI.createTicket(parameters: parameters)) { (result: Swift.Result<Tickets, APIError>) in
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
    
    static func getTickets(completion: @escaping (Swift.Result<Complaints, APIError>) -> Void) {
        
        APIManager.shared.request(urlRequest: TicketsAPI.getTickets) { (result: Swift.Result<Complaints, APIError>) in
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
