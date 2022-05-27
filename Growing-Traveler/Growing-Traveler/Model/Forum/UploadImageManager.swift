//
//  uploadImageManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/14.
//

import Foundation
import Alamofire

class UploadImageManager {
    
    let headers: HTTPHeaders = ["Authorization": "Client-ID \(ClientID().imgurClientID)"]
    
    let apiURL: String = "https://api.imgur.com/3/image"
    
    func uploadImage(uiImage: UIImage, completion: @escaping (Result<String>) -> Void) {
        
        HandleResult.imageUpload.messageHUD
        
        AF.upload(multipartFormData: { data in
            
            if let imageData = uiImage.jpegData(compressionQuality: 0.9) {
                
                data.append(imageData, withName: SendType.image.title)
                
            }
            
        }, to: apiURL, headers: headers)
        .responseDecodable(of: UploadImageResult.self, queue: .main, decoder: JSONDecoder()) { response in

            switch response.result {
                
            case .success(let result):
                
                HandleResult.imageUploadSuccess.messageHUD

                completion(Result.success("\(result.data.link)"))
                
            case .failure(let error):
                
                HandleResult.imageUploadFailed.messageHUD
                
                completion(Result.failure(error))
                
            }
            
        }
        
    }
}
