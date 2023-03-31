//
//  ApiClient.swift
//  garnify
//
//  Created by Vladyslav Oliinyk on 04.03.2023.
//

import UIKit
import Alamofire


extension Api {
    
    class Client {
        
        static let shared = Client()
        private let baseUrl = "http://localhost:8080"
        private let encoder = JSONEncoder()
        private let decoder = JSONDecoder()
        
        func sendRequest<T: Decodable>(endpoint: Api.Types.Endpoint,
                                       method: Api.Types.Method = .get,
                                       parameters: Parameters? = nil,
                                       body: Encodable? = nil,
                                       headers: HTTPHeaders? = nil,
                                       completion: @escaping (Result<T, Error>) -> Void) {
            let url = baseUrl + endpoint.url.path
            let httpMethod = HTTPMethod(rawValue: method.rawValue)
            let encoding: ParameterEncoding = (httpMethod == .get) ? URLEncoding.default : JSONEncoding.default
            
            AF.request(url, method: httpMethod, parameters: parameters, encoding: encoding, headers: headers)
                .validate()
                .response { response in
                    switch response.result {
                    case .success(let data):
                        if let data = data {
                            do {
                                let result = try self.decoder.decode(T.self, from: data)
                                completion(.success(result))
                            } catch {
                                completion(.failure(error))
                            }
                        } else {
                            let error = NSError(domain: "API Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                            completion(.failure(error))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
        
        func uploadImage<T: Decodable>(imageData: Data,
                                       requirements: Api.Types.Request.GarnifyNailsRequest.GarnifyRequirements,
                                       completion: @escaping (Result<T, Error>) -> Void) {
            let endpoint = Api.Types.Endpoint.playground(type: "nails")
            let body = Api.Types.Request.GarnifyNailsRequest(image: imageData, requirements: requirements)
            let headers: HTTPHeaders = [.contentType("multipart/form-data")]
            
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
                multipartFormData.append(try! self.encoder.encode(body.requirements), withName: "requirements")
            }, to: baseUrl + endpoint.url.path, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    if let data = data {
                        do {
                            let result = try self.decoder.decode(T.self, from: data)
                            completion(.success(result))
                        } catch {
                            completion(.failure(error))
                        }
                    } else {
                        let error = NSError(domain: "API Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
}
