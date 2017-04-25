//
//  IGRCropCornerView.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

@objc public class IGRCropCornerView: UIView {
    
    init(cornerType type: CropCornerType, lineWidth: CGFloat, lineLenght: CGFloat) {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: lineLenght, height: lineLenght))
        
        setup(cornerType: type, lineWidth: lineWidth, lineLenght:lineLenght)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup(cornerType: .upperRight, lineWidth: 2.0, lineLenght:kCropViewCornerLength)
    }
    
    fileprivate func setup(cornerType type: CropCornerType, lineWidth: CGFloat, lineLenght: CGFloat) {
        
        let horizontal = IGRCropCornerLine(frame: CGRect(x: 0.0,
                                                         y: 0.0,
                                                         width: lineLenght,
                                                         height: lineWidth))
        self.addSubview(horizontal)
        
        let vertical = IGRCropCornerLine(frame: CGRect(x: 0.0,
                                                       y: 0.0,
                                                       width: lineWidth,
                                                       height: lineLenght))
        self.addSubview(vertical)
        
        if type == .upperLeft {
            horizontal.center = CGPoint(x: (lineLenght / 2.0), y: (lineWidth / 2.0))
            vertical.center = CGPoint(x: (lineWidth / 2.0), y: (lineLenght / 2.0))
        }
        else if type == .upperRight {
            horizontal.center = CGPoint(x: (lineLenght / 2.0), y: (lineWidth / 2.0))
            vertical.center = CGPoint(x: (lineLenght - lineWidth / 2.0), y: (lineLenght / 2.0))
        }
        else if type == .lowerRight {
            horizontal.center = CGPoint(x: (lineLenght / 2.0), y: (lineLenght - lineWidth / 2.0))
            vertical.center = CGPoint(x: (lineLenght - lineWidth / 2.0), y: (lineLenght / 2.0))
        }
        else if type == .lowerLeft {
            horizontal.center = CGPoint(x: (lineLenght / 2.0), y: (lineLenght - lineWidth / 2.0))
            vertical.center = CGPoint(x: (lineWidth / 2.0), y: (lineLenght / 2.0))
        }
    }
}
