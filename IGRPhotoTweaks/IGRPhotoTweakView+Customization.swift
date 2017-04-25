//
//  IGRPhotoTweakView+Customization.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/25/17.
//
//

import Foundation

@objc public protocol IGRPhotoTweakViewCustomizationDelegate: NSObjectProtocol {
    /*
     Lines between mask and crop area
     */
    @objc optional func borderColor() -> UIColor
    
    @objc optional func borderWidth() -> CGFloat
    
    /*
     Corner of 2 border lines
     */
    @objc optional func cornerBorderWidth() -> CGFloat
    
    @objc optional func cornerBorderLength() -> CGFloat
    
    /*
     Mask customization
     */
    @objc optional func isHighlightMask() -> Bool
    
    @objc optional func highlightMaskAlphaValue() -> CGFloat
    
    /*
     Top offset for crop view
     */
    @objc optional func canvasHeaderHeigth() -> CGFloat
}

extension IGRPhotoTweakView {
    
    func borderColor() -> UIColor {
        return (self.customizationDelegate?.borderColor!())!
    }
    
    func borderWidth() -> CGFloat {
        return (self.customizationDelegate?.borderWidth!())!
    }
    
    func cornerBorderWidth() -> CGFloat {
        return (self.customizationDelegate?.cornerBorderWidth!())!
    }
    
    func cornerBorderLength() -> CGFloat {
        return (self.customizationDelegate?.cornerBorderLength!())!
    }
    
    func isHighlightMask() -> Bool {
        return (self.customizationDelegate?.isHighlightMask!())!
    }
    
    func highlightMaskAlphaValue() -> CGFloat {
        return (self.customizationDelegate?.highlightMaskAlphaValue!())!
    }
    
    func canvasHeaderHeigth() -> CGFloat {
        return (self.customizationDelegate?.canvasHeaderHeigth!())!
    }
}
