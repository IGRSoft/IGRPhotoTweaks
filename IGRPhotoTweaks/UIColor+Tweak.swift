//
//  UIColor+Tweak.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func cancelButton() -> UIColor {
        return UIColor(red: 0.09, green: 0.49, blue: 1, alpha: 1)
    }
    
    class func cancelButtonHighlighted() -> UIColor {
        return UIColor(red: 0.11, green: 0.17, blue: 0.26, alpha: 1)
    }
    
    class func saveButton() -> UIColor {
        return UIColor(red: 1, green: 0.8, blue: 0, alpha: 1)
    }
    
    class func saveButtonHighlighted() -> UIColor {
        return UIColor(red: 0.26, green: 0.23, blue: 0.13, alpha: 1)
    }
    
    class func resetButton() -> UIColor {
        return UIColor(red: 0.09, green: 0.49, blue: 1, alpha: 1)
    }
    
    class func resetButtonHighlighted() -> UIColor {
        return UIColor(red: 0.11, green: 0.17, blue: 0.26, alpha: 1)
    }
    
    class func mask() -> UIColor {
        return UIColor(white: 0.0, alpha: 0.6)
    }
    
    class func cropLine() -> UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }
    
    class func gridLine() -> UIColor {
        return UIColor(red: 0.52, green: 0.48, blue: 0.47, alpha: 0.8)
    }
    
    class func photoTweakCanvasBackground() -> UIColor {
        return UIColor(white: 0.0, alpha: 1.0)
    }
}
