//
//  SwipeableSectionHeader.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/5/10.
//

import UIKit

protocol SwipeableSectionHeaderDelegate{
    
    func deleteSection(section: Int)
    
}

class SwipeableSectionHeader: UIView {
    
    var section:Int = 0
    
    var container:UIView!
    
    var titleLabel:UILabel!
    
    var deleteButton:UIButton!
    
    var delegate:SwipeableSectionHeaderDelegate?
    
    var swipeLeft:UISwipeGestureRecognizer!
    
    var swipeRight:UISwipeGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black
        
        self.container = UIView()
        
        self.addSubview(container)
        
        self.titleLabel = UILabel()
        
        self.titleLabel.textColor = UIColor.white
        
        self.titleLabel.textAlignment = .center
        
        self.container.addSubview(self.titleLabel)
        
        self.deleteButton = UIButton(type: .custom)
        
        self.deleteButton.backgroundColor = UIColor(
            red: 0xfc/255, green: 0x21/255, blue: 0x25/255, alpha: 1)
        
        self.deleteButton.setTitle("刪除目標", for:.normal)
        
        self.deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        self.deleteButton.addTarget(self, action:#selector(buttonTapped(_:)), for:.touchUpInside)
        
        self.container.addSubview(self.deleteButton)
        
        self.swipeLeft = UISwipeGestureRecognizer(
            target:self, action:#selector(headerViewSwiped(_:)))
        
        self.swipeLeft.direction = .left
        
        self.addGestureRecognizer(self.swipeLeft)
        
        self.swipeRight = UISwipeGestureRecognizer(
            target:self, action:#selector(headerViewSwiped(_:)))
        
        self.swipeRight.direction = .right
        
        self.addGestureRecognizer(self.swipeRight)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    @objc func headerViewSwiped(_ recognizer:UISwipeGestureRecognizer) {
        
        if recognizer.state == .ended {
            
            var newFrame = self.container.frame
            
            if recognizer.direction == .left {
                
                newFrame.origin.x = -self.deleteButton.frame.width
                
            }else {
                
                newFrame.origin.x = 0
                
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                
                ()-> Void in
                
                self.container.frame = newFrame
                
            })
            
        }
        
    }
    
    @objc func buttonTapped(_ button:UIButton) {
        
        delegate?.deleteSection(section: section)
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.container.frame = CGRect(x: 0, y:0, width:self.frame.width + 74, height:self.frame.height)
        
        self.titleLabel.frame = CGRect(x: 0, y:0, width:self.frame.width, height:self.frame.height)
        
        self.deleteButton.frame = CGRect(x: self.frame.size.width, y:0, width:74, height:self.frame.height)
        
    }
    
}
