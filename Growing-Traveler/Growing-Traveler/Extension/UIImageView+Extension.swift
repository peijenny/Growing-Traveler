//
//  UIImageView+Extension.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/14.
//

import UIKit
import Kingfisher
import JXPhotoBrowser

extension UIImageView {

    func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {

        guard urlString != nil else { return }
        
        let url = URL(string: urlString!)

        self.kf.setImage(with: url, placeholder: placeHolder)
        
    }
    
    func showPhoto(imageView: UIImageView) {
        
        // 展示 image (pop-up Image 單獨顯示的視窗)
        let browser = JXPhotoBrowser()

        browser.numberOfItems = { 1 }

        browser.reloadCellAtIndex = { context in

            let browserCell = context.cell as? JXPhotoBrowserImageCell
            
            browserCell?.imageView.image = imageView.image
            
        }

        browser.show()
        
    }
    
}
