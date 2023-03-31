//
//  ApiTypes.swift
//  garnify
//
//  Created by Vladyslav Oliinyk on 04.03.2023.
//

import UIKit

extension Api{
    enum Types {
        enum Response{
            struct GarnifyResponse : Decodable{
                var id: Int
                var image: Data
            }
        }
        
        enum Request{
            struct GarnifyNailsRequest : Encodable{
                var image: Data
                var requirements: GarnifyRequirements
                
                struct GarnifyRequirements : Encodable{
                    var color: String
                    var tags: [String]
                    var length: LengthType
                    
                    enum LengthType : String, Encodable{
                        case short = "short"
                        case mid = "mid"
                        case long = "long"
                        case extraLong = "extra-long"
                    }
                }
            }
        }
        
        enum Endpoint{
            case playground(type : String)
            case auth(token: String)
            var url : URL {
                var components = URLComponents()
                components.host = "localhost:8080"
                components.scheme = "http"
                
                switch self{
                case .playground(let type):
                    components.path = "/playground/\(type)"
                case .auth(let token):
                    components.path = "/auth/\(token)"
                }
                
                return components.url!
            }
        }
        
        enum Method : String{
            case get
            case post
        }
    }
}
