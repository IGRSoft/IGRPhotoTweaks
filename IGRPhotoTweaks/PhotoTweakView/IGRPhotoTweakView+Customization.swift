//
//  IGRPhotoTweakView+Customization.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/25/17.
//
//

import Foundation

public protocol IGRPhotoTweakViewCustomizationDelegate : class {
    /*
     Lines between mask and crop area
     */
    func borderColor() -> UIColor
    
    func borderWidth() -> CGFloat
    
    /*
     Corner of 2 border lines
     */
    func cornerBorderWidth() -> CGFloat
    
    func cornerBorderLength() -> CGFloat
    
    /*
     Mask customization
     */
    func isHighlightMask() -> Bool
    
    func highlightMaskAlphaValue() -> CGFloat
    
    /*
     Top offset for crop view
     */
    func canvasHeaderHeigth() -> CGFloat
}

extension IGRPhotoTweakView {
    
    func borderColor() -> UIColor {
        return (self.customizationDelegate?.borderColor())!
    }
    
    func borderWidth() -> CGFloat {
        return (self.customizationDelegate?.borderWidth())!
    }
    
    func cornerBorderWidth() -> CGFloat {
        return (self.customizationDelegate?.cornerBorderWidth())!
    }
    
    func cornerBorderLength() -> CGFloat {
        return (self.customizationDelegate?.cornerBorderLength())!
    }
    
    func isHighlightMask() -> Bool {
        return (self.customizationDelegate?.isHighlightMask())!
    }
    
    func highlightMaskAlphaValue() -> CGFloat {
        return (self.customizationDelegate?.highlightMaskAlphaValue())!
    }
    
    func canvasHeaderHeigth() -> CGFloat {
        return (self.customizationDelegate?.canvasHeaderHeigth())!
    }
}
