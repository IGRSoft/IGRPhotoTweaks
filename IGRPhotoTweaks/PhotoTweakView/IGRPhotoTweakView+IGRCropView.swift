//
//  IGRPhotoTweakView+IGRCropView.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/26/17.
//
//

import Foundation

extension IGRPhotoTweakView {
    
    internal func setupCropView() {
        
        self.cropView.delegate = self
    }
}

extension IGRPhotoTweakView : IGRCropViewDelegate {
    
    public func cropViewDidStartCrop(_ cropView: IGRCropView) {
        self.highlightMask(true, animate: true)
        self.manualMove = true
    }
    
    public func cropViewDidMove(_ cropView: IGRCropView) {
        self.updateMasks()
    }
    
    public func cropViewDidStopCrop(_ cropView: IGRCropView) {
        let scaleX: CGFloat = self.originalSize.width / cropView.bounds.size.width
        let scaleY: CGFloat = self.originalSize.height / cropView.bounds.size.height
        let scale: CGFloat = min(scaleX, scaleY)
        
        // calculate the new bounds of crop view
        let newCropBounds = CGRect(x: CGFloat.zero,
                                   y: CGFloat.zero,
                                   width: (scale * cropView.frame.size.width),
                                   height: (scale * cropView.frame.size.height))
        
        // calculate the new bounds of scroll view
        let width: CGFloat = fabs(cos(self.angle)) * newCropBounds.size.width + fabs(sin(self.angle)) * newCropBounds.size.height
        let height: CGFloat = fabs(sin(self.angle)) * newCropBounds.size.width + fabs(cos(self.angle)) * newCropBounds.size.height
        
        // calculate the zoom area of scroll view
        var scaleFrame: CGRect = cropView.frame
        if scaleFrame.size.width >= self.scrollView.contentSize.width {
            scaleFrame.size.width = self.scrollView.contentSize.width - 1
        }
        if scaleFrame.size.height >= self.scrollView.contentSize.height {
            scaleFrame.size.height = self.scrollView.contentSize.height - 1
        }
        
        let contentOffset: CGPoint = self.scrollView.contentOffset
        let contentOffsetCenter = CGPoint(x: (contentOffset.x + self.scrollView.bounds.size.width.half),
                                          y: (contentOffset.y + self.scrollView.bounds.size.height.half))
        var bounds: CGRect = self.scrollView.bounds
        bounds.size.width = width
        bounds.size.height = height
        self.scrollView.bounds = CGRect(x: CGFloat.zero, y: CGFloat.zero, width: width, height: height)
        let newContentOffset = CGPoint(x: (contentOffsetCenter.x - self.scrollView.bounds.size.width.half),
                                       y: (contentOffsetCenter.y - self.scrollView.bounds.size.height.half))
        self.scrollView.contentOffset = newContentOffset
        
        UIView.animate(withDuration: kAnimationDuration, animations: {() -> Void in
            // animate crop view
            cropView.bounds = CGRect(x: CGFloat.zero,
                                     y: CGFloat.zero,
                                     width: (newCropBounds.size.width),
                                     height: (newCropBounds.size.height))
            cropView.center = CGPoint(x: self.frame.width.half, y: self.centerY)
            
            // zoom the specified area of scroll view
            let zoomRect: CGRect = self.convert(scaleFrame,
                                                to: self.scrollView.photoContentView)
            self.scrollView.zoom(to: zoomRect, animated: false)
        })
        
        self.manualZoomed = true
        
        // update masks
        self.cropView.dismissCropLines()
        self.cropView.dismissGridLines()
        
        let scaleH: CGFloat = self.scrollView.bounds.size.height / self.scrollView.contentSize.height
        let scaleW: CGFloat = self.scrollView.bounds.size.width / self.scrollView.contentSize.width
        var scaleM: CGFloat = max(scaleH, scaleW)
        scaleM = min(1.0, scaleM)
        
        UIView.animate(withDuration: kAnimationDuration, animations: {() -> Void in
            self.scrollView.checkContentOffset()
            self.cropView.layoutIfNeeded()
        })
        
        self.highlightMask(false, animate: true)
        self.manualMove = false
    }
    
    public func cropViewInsideValidFrame(for point: CGPoint, from cropView: IGRCropView) -> Bool {
        let updatedPoint = self.convert(point, to: self.scrollView.photoContentView)
        let frame =  self.scrollView.photoContentView.frame
        return frame.contains(updatedPoint)
    }
}
