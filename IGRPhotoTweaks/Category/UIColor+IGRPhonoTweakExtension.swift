//
//  UIColor+IGRPhonoTweakExtension.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func mask() -> UIColor {
        return UIColor(white: CGFloat.zero, alpha: 0.6)
    }
    
    class func cropLine() -> UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }
    
    class func gridLine() -> UIColor {
        return UIColor(red: 0.52, green: 0.48, blue: 0.47, alpha: 0.8)
    }
    
    class func photoTweakCanvasBackground() -> UIColor {
        return UIColor(white: CGFloat.zero, alpha: 1.0)
    }
}
