//
//  NailsApiService.swift
//  garnify_ios
//
//  Created by thermeto_home on 01.04.2023.
//

import Foundation
import Combine
import Firebase


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
    
    func sendImageToBackend(image: UIImage, userToken: String) async throws {
        let url = URL(string: "http://127.0.0.1:8000/nails/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(userToken)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = image.jpegData(compressionQuality: 0.5)!
        
        let body = NSMutableData()
        
        // add image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body as Data
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server responded with a non-200 status code"])
        }
        
        print("Image sent successfully")
    }


}
