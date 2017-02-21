//
//  IGRPhotoScrollView.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

protocol IGRPhotoScrollViewDelegate: NSObjectProtocol {
    /*
     Calls ones, when user start interaction with view
     */
    func scrollViewDidStartUpdateScrollContentOffset(_ scrollView: UIScrollView)
    
    /*
     Calls ones, when user stop interaction with view
     */
    func scrollViewDidStopScrollUpdateContentOffset(_ scrollView: UIScrollView)
}

class IGRPhotoScrollView: UIScrollView {
    
    //MARK: - Public VARs
    
    /*
     View for func viewForZooming(in scrollView: UIScrollView)
     */
    var photoContentView: IGRPhotoContentView!
    
    /*
     The optional scroll delegate.
     */
    weak var updateDelegate: IGRPhotoScrollViewDelegate?
    
    //MARK: - Protected VARs
    
    fileprivate var isUpdatingContentOffset = false
    
    //MARK: - Content Offsets
    
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
            IGRPhotoScrollView.cancelPreviousPerformRequests(withTarget: self,
                                                             selector: selector,
                                                             object: nil)
            perform(selector, with: nil, afterDelay: 0.5)
        }
        get {
            return super.contentOffset
        }
    }
    
    func stopUpdateContentOffset() {
        if (isUpdatingContentOffset && updateDelegate != nil) {
            isUpdatingContentOffset = false
            updateDelegate?.scrollViewDidStopScrollUpdateContentOffset(self)
        }
    }
    
    //MARK: - Zoom
    
    func zoomScaleToBound() -> CGFloat {
        let scaleW: CGFloat = self.bounds.size.width / self.photoContentView.bounds.size.width
        let scaleH: CGFloat = self.bounds.size.height / self.photoContentView.bounds.size.height
        
        return max(scaleW, scaleH)
    }
}
