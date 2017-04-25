//
//  IGRPhotoTweakViewController+Customization.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/25/17.
//
//

import Foundation

extension IGRPhotoTweakViewController {
    
    //MARK: - Customization
    
    open func customBorderColor() -> UIColor {
        return UIColor.cropLine()
    }
    
    open func customBorderWidth() -> CGFloat {
        return 1.0
    }
    
    open func customCornerBorderWidth() -> CGFloat {
        return kCropViewCornerWidth
    }
    
    open func customCornerBorderLength() -> CGFloat {
        return kCropViewCornerLength
    }
    
    open func customIsHighlightMask() -> Bool {
        return true
    }
    
    open func customHighlightMaskAlphaValue() -> CGFloat {
        return 0.3
    }
    
    open func customCanvasHeaderHeigth() -> CGFloat {
        return kCanvasHeaderHeigth
    }
}

//MARK: - Delegats funcs

extension IGRPhotoTweakViewController : IGRPhotoTweakViewCustomizationDelegate {
    public func borderColor() -> UIColor {
        return self.customBorderColor()
    }
    
    public func borderWidth() -> CGFloat {
        return self.customBorderWidth()
    }
    
    public func cornerBorderWidth() -> CGFloat {
        return self.customCornerBorderWidth()
    }
    
    public func cornerBorderLength() -> CGFloat {
        return self.customCornerBorderLength()
    }
    
    public func isHighlightMask() -> Bool {
        return self.customIsHighlightMask()
    }
    
    public func highlightMaskAlphaValue() -> CGFloat {
        return self.customHighlightMaskAlphaValue()
    }
    
    public func canvasHeaderHeigth() -> CGFloat {
        return self.customCanvasHeaderHeigth()
    }
}
