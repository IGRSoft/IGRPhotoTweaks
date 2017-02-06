//
//  IGRPhotoContentView.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

class IGRPhotoContentView: UIView {
    var imageView: UIImageView!
    var image: UIImage! {
        didSet {
            self.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(image.size.width), height: CGFloat(image.size.height))
            
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
