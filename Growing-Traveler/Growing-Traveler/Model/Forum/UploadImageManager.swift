//
//  uploadImageManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/14.
//

import Foundation
import Alamofire

class UploadImageManager {
    
    let headers: HTTPHeaders = ["Authorization": "Client-ID \(clientID)"]
    
    let apiURL: String = "https://api.imgur.com/3/image"
    
    func uploadImage(uiImage: UIImage, completion: @escaping (Result<String>) -> Void) {
        
        AF.upload(multipartFormData: { data in
            
            if let imageData = uiImage.jpegData(compressionQuality: 0.9) {
                
                data.append(imageData, withName: "image")
                
            }
            
        }, to: apiURL, headers: headers)
        .responseDecodable(of: UploadImageResult.self, queue: .main, decoder: JSONDecoder()) { response in

            switch response.result {
                
            case .success(let result):
                
                completion(Result.success("\(result.data.link)"))
                
            case .failure(let error):
                
                completion(Result.failure(error))
                
            }
            
        }
        
    }
}
