//
//  uploadImageManager.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/14.
//

import Foundation
import Alamofire
import PKHUD

class UploadImageManager {
    
    let headers: HTTPHeaders = ["Authorization": "Client-ID \(ClientID().imgurClientID)"]
    
    let apiURL: String = "https://api.imgur.com/3/image"
    
    func uploadImage(uiImage: UIImage, completion: @escaping (Result<String>) -> Void) {
        
        HUD.show(.labeledProgress(title: "圖片上傳中...", subtitle: nil))
        
        AF.upload(multipartFormData: { data in
            
            if let imageData = uiImage.jpegData(compressionQuality: 0.9) {
                
                data.append(imageData, withName: SendType.image.title)
                
            }
            
        }, to: apiURL, headers: headers)
        .responseDecodable(of: UploadImageResult.self, queue: .main, decoder: JSONDecoder()) { response in

            switch response.result {
                
            case .success(let result):

                HUD.flash(.labeledSuccess(title: "圖片上傳成功！", subtitle: nil))
                
                completion(Result.success("\(result.data.link)"))
                
            case .failure(let error):
                
                HUD.flash(.labeledError(title: "圖片上傳失敗！", subtitle: nil))
                
                completion(Result.failure(error))
                
            }
            
        }
        
    }
}
