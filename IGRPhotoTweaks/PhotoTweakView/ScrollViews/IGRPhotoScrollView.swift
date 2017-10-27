//
//  IGRPhotoswift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

public protocol IGRPhotoScrollViewDelegate : class{
    /*
     Calls ones, when user start interaction with view
     */
    func scrollViewDidStartUpdateScrollContentOffset(_ scrollView: IGRPhotoScrollView)
    
    /*
     Calls ones, when user stop interaction with view
     */
    func scrollViewDidStopScrollUpdateContentOffset(_ scrollView: IGRPhotoScrollView)
}

public class IGRPhotoScrollView: UIScrollView {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    fileprivate func setup() {
        self.bounces = true
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.alwaysBounceVertical = true
        self.alwaysBounceHorizontal = true
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 10.0
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.clipsToBounds = false
        self.contentSize = CGSize(width: self.bounds.size.width,
                                  height: self.bounds.size.height)
    }
    
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
    
    override public var contentOffset: CGPoint {
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
    
    @objc func stopUpdateContentOffset() {
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
