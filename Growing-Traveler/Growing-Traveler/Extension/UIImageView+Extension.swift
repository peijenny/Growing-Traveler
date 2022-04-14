//
//  UIImageView+Extension.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/14.
//

import UIKit

extension UIImageView {
    
    func load(url: URL) {
        
        DispatchQueue.global().async { [weak self] in
            
            if let data = try? Data(contentsOf: url) {
                
                if let image = UIImage(data: data) {
                    
                    DispatchQueue.main.async {
                        
                        self?.image = image
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
