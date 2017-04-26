//
//  IGRPhotoTweakView+UIScrollView.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/26/17.
//
//

import Foundation

extension IGRPhotoTweakView {
    
    internal func setupScrollView() {
        self.scrollView.updateDelegate = self
        
        self.photoContentView.image = image
        self.scrollView.photoContentView = self.photoContentView
    }
}

extension IGRPhotoTweakView : UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoContentView
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.cropView.updateCropLines(animate: true)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.manualZoomed = true
        self.cropView.dismissCropLines()
    }
}

extension IGRPhotoTweakView : IGRPhotoScrollViewDelegate {
    public func scrollViewDidStartUpdateScrollContentOffset(_ scrollView: IGRPhotoScrollView) {
        self.highlightMask(true, animate: true)
    }
    
    public func scrollViewDidStopScrollUpdateContentOffset(_ scrollView: IGRPhotoScrollView) {
        self.updateMasks()
        self.highlightMask(false, animate: true)
    }
}
