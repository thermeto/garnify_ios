//
//  NailsApiService.swift
//  garnify_ios
//
//  Created by thermeto_home on 01.04.2023.
//

import Foundation
import Combine
import Firebase
import SwiftUI


class NailsApiService : ObservableObject{
    static let shared = NailsApiService()
    
    public init() {}
    
    func getUserToken() async throws -> String {
        if let currentUser = Auth.auth().currentUser {
            let tokenResult = try await currentUser.getIDTokenResult()
            return tokenResult.token
        } else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No current user"])
        }
    }
    
    func sendGarnifyNailsRequest(
        image: UIImage,
        selectedTags: [String],
        selectedColorHex: String,
        selectedLength: Api.Types.Request.GarnifyNailsRequest.GarnifyRequirements.LengthType,
        imageURL: URL
    ) async throws -> (UIImage, String) {
        let userToken = try await getUserToken()
        let url = URL(string: "http://127.0.0.1:8000/nails/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(userToken)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = image.jpegData(compressionQuality: 0.5)!
        
        let body = NSMutableData()
        let imageFilename = imageURL.lastPathComponent
        body.appendFormData(name: "image", filename: imageFilename, contentType: "image/jpeg", data: imageData, using: boundary)
        let selectedTagsString = selectedTags.joined(separator: ",")
        body.appendFormData(name: "selectedTags", value: selectedTagsString, using: boundary)
        body.appendFormData(name: "selectedColor", value: selectedColorHex, using: boundary)
        body.appendFormData(name: "selectedLength", value: selectedLength.rawValue, using: boundary)
            
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body as Data
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server responded with a non-200 status code"])
        }
        
        let decoder = JSONDecoder()
        let garnifyResult = try decoder.decode(GarnifyNailsResponse.self, from: data)
        
        guard let imageDataResponse = Data(base64Encoded: garnifyResult.image) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to decode base64 image data"])
        }
        
        guard let receivedImage = UIImage(data: imageDataResponse) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to create UIImage from data"])
        }
        
        return (receivedImage, garnifyResult.receivedDateTime)
    }

}

extension NSMutableData {
    func appendFormData(name: String, value: String, using boundary: String) {
        append("--\(boundary)\r\n".data(using: .utf8)!)
        append("Content-Disposition: form-data; name=\"\(name)\"\r\n".data(using: .utf8)!)
        append("\r\n".data(using: .utf8)!)
        append(value.data(using: .utf8)!)
        append("\r\n".data(using: .utf8)!)
    }
    
    func appendFormData(name: String, filename: String, contentType: String, data: Data, using boundary: String) {
        append("--\(boundary)\r\n".data(using: .utf8)!)
        append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        append("Content-Type: \(contentType)\r\n\r\n".data(using: .utf8)!)
        append(data)
        append("\r\n".data(using: .utf8)!)
    }
}
