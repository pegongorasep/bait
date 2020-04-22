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
    case getTickets(parameters: Parameters)
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
            return "complaints"
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
            case .getTickets(let parameters):
                return parameters
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
        
    static func createTicket(title: String, description: String, condominium_id: String, user_id: String, image: UIImage?, completion: @escaping (Swift.Result<Tickets, APIError>) -> Void) {
        
        var parameters: Parameters = [
            "title": title,
            "description": description,
            "condominium_id": condominium_id,
            "user_id":  user_id,
            "complaint_state_id": 3
        ]
        
        var imageFileData: [MultipartModel]?
        
        if let picture = image {
            parameters["file_count"] = 1
            
            let imageData = picture.jpegData(compressionQuality: 0.4)!
            let userId = Constants.user?.user.id
            let timestamp = Date().timeIntervalSinceNow
            let fileName = "\(userId!)\(timestamp).jpeg"
            imageFileData = [MultipartModel(data: imageData, name: fileName, key: "file[1]", mimeType: "image/jpeg")]
            
            APIManager.shared.upload(urlRequest: TicketsAPI.createTicket(parameters: parameters), parameters: parameters, multipartForms: imageFileData!) { (result: Swift.Result<Tickets, APIError>) in
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

        } else {
            parameters["file_count"] = 0
            parameters["file[0]"] = 0
        
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
    }
    
    static func getTickets(page: Int, completion: @escaping (Swift.Result<Complaints, APIError>) -> Void) {

        let parameters: Parameters = [
            "page":page
        ]
        
        APIManager.shared.request(urlRequest: TicketsAPI.getTickets(parameters: parameters)) { (result: Swift.Result<Complaints, APIError>) in
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
