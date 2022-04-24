//
//  ProfileView.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/22.
//

import UIKit

class ProfileView: UIView, NibOwnerLoadable {

    @IBOutlet weak var profileBackgroundView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customInit()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        customInit()
        
    }
    
    private func customInit() {
        
        loadNibContent()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        profileBackgroundView.layer.borderWidth = 0.5
        
        profileBackgroundView.layer.borderColor = UIColor.lightGray.cgColor
        
    }

}
