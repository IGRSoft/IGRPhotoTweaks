//
//  IGRCropCornerView.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

class IGRCropCornerView: UIView {

    init(cornerType type: CropCornerType) {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: kCropViewCornerLength, height: kCropViewCornerLength))
        
        setup(cornerType: type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup(cornerType: .upperRight)
    }
    
    fileprivate func setup(cornerType type: CropCornerType) {
        self.backgroundColor = UIColor.clear
        let lineWidth: CGFloat = 2
        
        let horizontal = UIView(frame: CGRect(x: 0.0, y: 0.0, width: kCropViewCornerLength, height: lineWidth))
        horizontal.backgroundColor = UIColor.cropLine()
        self.addSubview(horizontal)
        
        let vertical = UIView(frame: CGRect(x: 0.0, y: 0.0, width: lineWidth, height: kCropViewCornerLength))
        vertical.backgroundColor = UIColor.cropLine()
        self.addSubview(vertical)
        
        if type == .upperLeft {
            horizontal.center = CGPoint(x: (kCropViewCornerLength / 2.0), y: (lineWidth / 2.0))
            vertical.center = CGPoint(x: (lineWidth / 2.0), y: (kCropViewCornerLength / 2.0))
        }
        else if type == .upperRight {
            horizontal.center = CGPoint(x: (kCropViewCornerLength / 2.0), y: (lineWidth / 2.0))
            vertical.center = CGPoint(x: (kCropViewCornerLength - lineWidth / 2.0), y: (kCropViewCornerLength / 2.0))
        }
        else if type == .lowerRight {
            horizontal.center = CGPoint(x: (kCropViewCornerLength / 2.0), y: (kCropViewCornerLength - lineWidth / 2.0))
            vertical.center = CGPoint(x: (kCropViewCornerLength - lineWidth / 2.0), y: (kCropViewCornerLength / 2.0))
        }
        else if type == .lowerLeft {
            horizontal.center = CGPoint(x: (kCropViewCornerLength / 2.0), y: (kCropViewCornerLength - lineWidth / 2.0))
            vertical.center = CGPoint(x: (lineWidth / 2.0), y: (kCropViewCornerLength / 2.0))
        }
    }
}
