//
//  IGRPhotoTweakView+Angle.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/26/17.
//
//

import Foundation

extension IGRPhotoTweakView {
    public func changeAngle(radians: CGFloat) {
        // update masks
        self.highlightMask(true, animate: false)
        
        // update grids
        self.cropView.updateGridLines(animate: false)
        
        // rotate scroll view
        self.radians = radians
        self.scrollView.transform = CGAffineTransform(rotationAngle: self.radians)
        
        self.updatePosition()
    }
    
    public func stopChangeAngle() {
        self.cropView.dismissGridLines()
        self.highlightMask(false, animate: false)
    }
}
