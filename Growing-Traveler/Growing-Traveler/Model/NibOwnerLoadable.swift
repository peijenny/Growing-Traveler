//
//  NibOwnerLoadable.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/22.
//

import UIKit

// 方便使用的框架，負責用來載入 Nib 檔案

protocol NibOwnerLoadable: AnyObject {
    
    static var nib: UINib { get }
    
}

// MARK: - Default implmentation
extension NibOwnerLoadable {
    
    static var nib: UINib {
        
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
        
    }
}

// MARK: - Supporting methods
extension NibOwnerLoadable where Self: UIView {
    
    func loadNibContent() {
        
        guard let views = Self.nib.instantiate(withOwner: self, options: nil) as? [UIView],
            let contentView = views.first else {
                fatalError("Fail to load \(self) nib content")
        }
        self.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
    
}

