//
//  IGRPhotoTweakViewController+Customization.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/25/17.
//
//

import Foundation

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
