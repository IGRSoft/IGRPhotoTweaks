//
//  IGRPhotoContentView.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

class IGRPhotoContentView: UIView {
    
    override class func initialize () {
        self.appearance().backgroundColor = UIColor.clear
    }
    
    var imageView: UIImageView!
    var image: UIImage! {
        didSet {
            let imageViewExist = self.imageView != nil
            if !imageViewExist {
                self.imageView = UIImageView(frame: self.bounds)
                self.addSubview(self.imageView)
            }
            else {
                self.imageView.frame = self.bounds
            }
            
            self.imageView.image = self.image
            self.imageView.isUserInteractionEnabled = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = self.bounds
    }
}
