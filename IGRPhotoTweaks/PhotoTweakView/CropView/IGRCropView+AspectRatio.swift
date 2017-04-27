//
//  IGRCropView+AspectRatio.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/26/17.
//
//

import Foundation

extension IGRCropView {
    
    public func setCropAspectRect(aspect: String, maxSize: CGSize) {
        let elements = aspect.components(separatedBy: ":")
        let width: CGFloat = CGFloat(Float(elements.first!)!)
        let height: CGFloat = CGFloat(Float(elements.last!)!)
        
        var size = maxSize
        let mW = size.width / width
        let mH = size.height / height
        
        if (mH < mW) {
            size.width = size.height / height * width
        }
        else if(mW < mH) {
            size.height = size.width / width * height
        }
        
        let x = (self.frame.size.width - size.width).half
        let y = (self.frame.size.height - size.height).half
        
        self.frame = CGRect(x:x, y:y, width: size.width, height: size.height)
    }
}
