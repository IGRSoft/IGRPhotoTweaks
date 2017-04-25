//
//  IGRPhotoswift
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
    
    public func checkContentOffset() {
        self.setContentOffsetX(max(self.contentOffset.x, 0))
        self.setContentOffsetY(max(self.contentOffset.y, 0))
        
        if self.contentSize.height - self.contentOffset.y <= self.bounds.size.height {
            self.setContentOffsetY(self.contentSize.height - self.bounds.size.height)
        }
        
        if self.contentSize.width - self.contentOffset.x <= self.bounds.size.width {
            self.setContentOffsetX(self.contentSize.width - self.bounds.size.width)
        }
    }
    
    public func setContentOffsetY(_ offsetY: CGFloat) {
        var contentOffset: CGPoint = self.contentOffset
        contentOffset.y = offsetY
        self.contentOffset = contentOffset
    }
    
    public func setContentOffsetX(_ offsetX: CGFloat) {
        var contentOffset: CGPoint = self.contentOffset
        contentOffset.x = offsetX
        self.contentOffset = contentOffset
    }
    
    override var contentOffset: CGPoint {
        set {
            super.contentOffset = newValue
            
            if (!isUpdatingContentOffset) {
                isUpdatingContentOffset = true
                updateDelegate?.scrollViewDidStartUpdateScrollContentOffset(self)
            }
            
            let selector = #selector(self.stopUpdateContentOffset)
            IGRPhotoScrollView.cancelPreviousPerformRequests(withTarget: self,
                                                             selector: selector,
                                                             object: nil)
            perform(selector, with: nil, afterDelay: kAnimationDuration * 2.0)
        }
        get {
            return super.contentOffset
        }
    }
    
    final func stopUpdateContentOffset() {
        if (isUpdatingContentOffset) {
            isUpdatingContentOffset = false
            updateDelegate?.scrollViewDidStopScrollUpdateContentOffset(self)
        }
    }
    
    //MARK: - Zoom
    
    public func zoomScaleToBound() -> CGFloat {
        let scaleW: CGFloat = self.bounds.size.width / self.photoContentView.bounds.size.width
        let scaleH: CGFloat = self.bounds.size.height / self.photoContentView.bounds.size.height
        
        return max(scaleW, scaleH)
    }
}
