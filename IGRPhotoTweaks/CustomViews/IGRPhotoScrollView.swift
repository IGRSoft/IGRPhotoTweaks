//
//  IGRPhotoScrollView.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

protocol IGRPhotoScrollViewDelegate: NSObjectProtocol {
    func scrollViewDidStartUpdateScrollContentOffset(_ scrollView: UIScrollView)
    func scrollViewDidStopScrollUpdateContentOffset(_ scrollView: UIScrollView)
}

class IGRPhotoScrollView: UIScrollView {
    var photoContentView: IGRPhotoContentView!
    
    weak var updateDelegate: IGRPhotoScrollViewDelegate?
    fileprivate var isUpdatingContentOffset = false
    
    func setContentOffsetY(_ offsetY: CGFloat) {
        var contentOffset: CGPoint = self.contentOffset
        contentOffset.y = offsetY
        self.contentOffset = contentOffset
    }
    
    func setContentOffsetX(_ offsetX: CGFloat) {
        var contentOffset: CGPoint = self.contentOffset
        contentOffset.x = offsetX
        self.contentOffset = contentOffset
    }
    
    override var contentOffset: CGPoint {
        set {
            super.contentOffset = newValue
            
            if (!isUpdatingContentOffset && updateDelegate != nil) {
                isUpdatingContentOffset = true
                updateDelegate?.scrollViewDidStartUpdateScrollContentOffset(self)
            }
            
            let selector = #selector(self.stopUpdateContentOffset)
            IGRPhotoScrollView.cancelPreviousPerformRequests(withTarget: self, selector: selector, object: nil)
            perform(selector, with: nil, afterDelay: 0.5)
        }
        get {
            return super.contentOffset
        }
    }
    
    func zoomScaleToBound() -> CGFloat {
        let scaleW: CGFloat = self.bounds.size.width / self.photoContentView.bounds.size.width
        let scaleH: CGFloat = self.bounds.size.height / self.photoContentView.bounds.size.height
        
        return max(scaleW, scaleH)
    }
    
    func stopUpdateContentOffset() {
        if (isUpdatingContentOffset && updateDelegate != nil) {
            isUpdatingContentOffset = false
            updateDelegate?.scrollViewDidStopScrollUpdateContentOffset(self)
        }
    }
}
