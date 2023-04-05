//
//  GarnifyNailsResponse.swift
//  garnify_ios
//
//  Created by thermeto_home on 05.04.2023.
//

import Foundation


struct GarnifyNailsResponse: Decodable {
    let image: String
    let receivedDateTime: String

    enum CodingKeys: String, CodingKey {
        case image
        case receivedDateTime = "received_datetime"
    }
}
