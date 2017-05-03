//
//  IGRCropView+UITouch.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/26/17.
//
//

import Foundation

extension IGRCropView {
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            self.updateCropLines(animate: false)
        }
        
        self.delegate?.cropViewDidStartCrop(self)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            let location: CGPoint = (touches.first?.location(in: self))!
            var frame: CGRect = self.frame
            
            let p0 = CGPoint(x: CGFloat.zero, y: CGFloat.zero)
            let p1 = CGPoint(x: self.frame.size.width, y: CGFloat.zero)
            let p2 = CGPoint(x: CGFloat.zero, y: self.frame.size.height)
            let p3 = CGPoint(x: self.frame.size.width, y: self.frame.size.height)
            
            if location.distanceTo(point: p0) < kCropViewHotArea {
                frame.origin.x += location.x
                frame.size.width -= location.x
                frame.origin.y += location.y
                frame.size.height -= location.y
            }
            else if location.distanceTo(point: p1) < kCropViewHotArea {
                frame.size.width = location.x
                frame.origin.y += location.y
                frame.size.height -= location.y
            }
            else if location.distanceTo(point: p2) < kCropViewHotArea {
                frame.origin.x += location.x
                frame.size.width -= location.x
                frame.size.height = location.y
            }
            else if location.distanceTo(point: p3) < kCropViewHotArea {
                frame.size.width = location.x
                frame.size.height = location.y
            }
            else if fabs(location.x - p0.x) < kCropViewHotArea {
                frame.origin.x += location.x
                frame.size.width -= location.x
            }
            else if fabs(location.x - p1.x) < kCropViewHotArea {
                frame.size.width = location.x
            }
            else if fabs(location.y - p0.y) < kCropViewHotArea {
                frame.origin.y += location.y
                frame.size.height -= location.y
            }
            else if fabs(location.y - p2.y) < kCropViewHotArea {
                frame.size.height = location.y
            }
            
            // If Aspect ratio is Freezed reset frame as per the aspect ratio
            if self.isAspectRatioLocked {
                let newHeight = (self.aspectRatioHeight / self.aspectRatioWidth) * frame.size.width
                frame = CGRect(x: frame.origin.x,
                               y: frame.origin.y,
                               width: frame.size.width,
                               height: newHeight)
            }

            //TODO: Added test cropViewInsideValidFrame
            
            if (frame.size.width > self.cornerBorderLength
                && frame.size.height > self.cornerBorderLength) {
                self.frame = frame
                // update crop lines
                self.updateCropLines(animate: false)
                
                self.delegate?.cropViewDidMove(self)
            }
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.cropViewDidStopCrop(self)
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.cropViewDidStopCrop(self)
    }
}
