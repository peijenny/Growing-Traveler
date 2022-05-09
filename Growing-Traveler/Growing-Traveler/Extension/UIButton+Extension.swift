//
//  UIButton+Extension.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/9.
//

import UIKit

extension UIButton {
    
    @objc func setTitle(_ title: String?) {
        
        self.setTitle(title, for: .normal)
        
        self.setTitle(title, for: .highlighted)
        
        self.setTitle(title, for: .selected)
        
    }
    
}
