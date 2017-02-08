//
//  IGRPhotoTweakView.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

protocol IGRPhotoTweakViewCustomizationDelegate: NSObjectProtocol {
    func borderColor() -> UIColor
    
    func borderWidth() -> CGFloat
    
    func cornerBorderWidth() -> CGFloat
    
    func cornerBorderLength() -> CGFloat
}

class IGRPhotoTweakView: UIView {
    override class func initialize () {
        self.appearance().backgroundColor = UIColor.photoTweakCanvasBackground()
    }
    
    open weak var customizationDelegate: IGRPhotoTweakViewCustomizationDelegate?
    
    var isHighlightMask: Bool = false
    var highlightMaskAlphaValue: CGFloat = 0.5
    
    private(set) var angle:                 CGFloat = 0.0
    private(set) var photoContentOffset =   CGPoint.zero
    private(set) var cropView:              IGRCropView!
    private(set) var photoContentView:      IGRPhotoContentView!
    
    var photoTranslation: CGPoint {
        get {
            let rect: CGRect = self.photoContentView.convert(self.photoContentView.bounds, to: self)
            let point = CGPoint(x: (rect.origin.x + rect.size.width / 2.0),
                                y: (rect.origin.y + rect.size.height / 2.0))
            let zeroPoint = CGPoint(x: (self.frame.width / 2.0), y: self.centerY)
            
            return CGPoint(x: (point.x - zeroPoint.x), y: (point.y - zeroPoint.y))
        }
    }
    
    fileprivate var scrollView: IGRPhotoScrollView!
    
    fileprivate var image: UIImage!
    fileprivate var originalSize = CGSize.zero
    
    fileprivate var manualZoomed = false

    // masks
    fileprivate var topMask: UIView!
    fileprivate var leftMask: UIView!
    fileprivate var bottomMask: UIView!
    fileprivate var rightMask: UIView!
    
    // constants
    fileprivate var maximumCanvasSize: CGSize!
    fileprivate var centerY: CGFloat!
    fileprivate var originalPoint: CGPoint!
    
    init(frame: CGRect, image: UIImage, customizationDelegate: IGRPhotoTweakViewCustomizationDelegate!) {
        super.init(frame: frame)
    
        self.image = image
        self.customizationDelegate = customizationDelegate
        
        // scale the image
        self.maximumCanvasSize = CGSize(width: (kMaximumCanvasWidthRatio * self.frame.size.width),
                                        height: (kMaximumCanvasHeightRatio * self.frame.size.height - kCanvasHeaderHeigth))
        let scaleX: CGFloat = image.size.width / self.maximumCanvasSize.width
        let scaleY: CGFloat = image.size.height / self.maximumCanvasSize.height
        let scale: CGFloat = max(scaleX, scaleY)
        let bounds = CGRect(x: 0.0,
                            y: 0.0,
                            width: (image.size.width / scale),
                            height: (image.size.height / scale))
        self.originalSize = bounds.size
        self.centerY = self.maximumCanvasSize.height / 2.0 + kCanvasHeaderHeigth
        
        self.scrollView = IGRPhotoScrollView(frame: bounds)
        self.scrollView.updateDelegate = self
        self.scrollView.center = CGPoint(x: (self.frame.width / 2.0), y: self.centerY)
        self.scrollView.bounces = true
        self.scrollView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.alwaysBounceHorizontal = true
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 10.0
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.clipsToBounds = false
        self.scrollView.contentSize = CGSize(width: self.scrollView.bounds.size.width,
                                             height: self.scrollView.bounds.size.height)
        self.addSubview(self.scrollView)

        self.photoContentView = IGRPhotoContentView(frame: self.scrollView.bounds)
        self.photoContentView.image = image
        self.photoContentView.isUserInteractionEnabled = true
        
        self.scrollView.photoContentView = self.photoContentView
        self.scrollView.addSubview(self.photoContentView)
        
        self.cropView = IGRCropView(frame: self.scrollView.frame,
                                    cornerBorderWidth:self.cornerBorderWidth(),
                                    cornerBorderLength:self.cornerBorderLength())
        self.cropView.center = self.scrollView.center
        self.cropView.delegate = self
        self.cropView.layer.borderColor = self.borderColor().cgColor
        self.cropView.layer.borderWidth = self.borderWidth()
        self.addSubview(self.cropView)
        
        self.topMask = IGRCropMaskView()
        self.addSubview(self.topMask)
        
        self.leftMask = IGRCropMaskView()
        self.addSubview(self.leftMask)
        
        self.bottomMask = IGRCropMaskView()
        self.addSubview(self.bottomMask)
        
        self.rightMask = IGRCropMaskView()
        self.addSubview(self.rightMask)
        self.updateMasks(false)
        
        self.originalPoint = self.convert(self.scrollView.center, to: self)
    }
    
    func borderColor() -> UIColor {
        return (self.customizationDelegate?.borderColor())!
    }
    
    func borderWidth() -> CGFloat {
        return (self.customizationDelegate?.borderWidth())!
    }
    
    func cornerBorderWidth() -> CGFloat {
        return (self.customizationDelegate?.cornerBorderWidth())!
    }
    
    func cornerBorderLength() -> CGFloat {
        return (self.customizationDelegate?.cornerBorderLength())!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.cropView.frame.insetBy(dx: -kCropViewHotArea, dy: -kCropViewHotArea).contains(point) &&
            !self.cropView.frame.insetBy(dx: kCropViewHotArea, dy: kCropViewHotArea).contains(point) {
            
            return self.cropView
        }
        
        return self.scrollView
    }
    
    fileprivate func updateMasks(_ animate: Bool) {
        let animationBlock: ((_: Void) -> Void)? = {(_: Void) -> Void in
            self.topMask.frame = CGRect(x: 0.0,
                                        y: 0.0,
                                        width: (self.cropView.frame.origin.x + self.cropView.frame.size.width),
                                        height: self.cropView.frame.origin.y)
            self.leftMask.frame = CGRect(x: 0.0,
                                         y: self.cropView.frame.origin.y,
                                         width: self.cropView.frame.origin.x,
                                         height: self.frame.size.height - self.cropView.frame.origin.y)
            self.bottomMask.frame = CGRect(x: self.cropView.frame.origin.x,
                                           y: (self.cropView.frame.origin.y + self.cropView.frame.size.height),
                                           width: (self.frame.size.width - self.cropView.frame.origin.x),
                                           height: (self.frame.size.height - (self.cropView.frame.origin.y + self.cropView.frame.size.height)))
            self.rightMask.frame = CGRect(x: (self.cropView.frame.origin.x + self.cropView.frame.size.width),
                                          y: 0.0,
                                          width: (self.frame.size.width - (self.cropView.frame.origin.x + self.cropView.frame.size.width)),
                                          height: (self.cropView.frame.origin.y + self.cropView.frame.size.height))
        }
        if animate {
            UIView.animate(withDuration: 0.25, animations: animationBlock!)
        }
        else {
            animationBlock!()
        }
    }
    
    fileprivate func highlightMask(_ highlight:Bool, animate: Bool) {
        if isHighlightMask {
            let newAlphaValue: CGFloat = highlight ? highlightMaskAlphaValue : 1.0
            
            let animationBlock: ((_: Void) -> Void)? = {(_: Void) -> Void in
                self.topMask.alpha = newAlphaValue
                self.leftMask.alpha = newAlphaValue
                self.bottomMask.alpha = newAlphaValue
                self.rightMask.alpha = newAlphaValue
            }
            
            if animate {
                UIView.animate(withDuration: 0.25, animations: animationBlock!)
            }
            else {
                animationBlock!()
            }
        }
    }
    
    fileprivate func checkScrollViewContentOffset() {
        self.scrollView.setContentOffsetX(max(self.scrollView.contentOffset.x, 0))
        self.scrollView.setContentOffsetY(max(self.scrollView.contentOffset.y, 0))
        
        if self.scrollView.contentSize.height - self.scrollView.contentOffset.y <= self.scrollView.bounds.size.height {
            self.scrollView.setContentOffsetY(self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
        }
        
        if self.scrollView.contentSize.width - self.scrollView.contentOffset.x <= self.scrollView.bounds.size.width {
            self.scrollView.setContentOffsetX(self.scrollView.contentSize.width - self.scrollView.bounds.size.width)
        }
    }
    
    open func changedAngel(value: CGFloat) {
        // update masks
        self.updateMasks(false)
        
        // update grids
        self.cropView.updateGridLines(false)
        
        // rotate scroll view
        self.angle = value
        self.scrollView.transform = CGAffineTransform(rotationAngle: self.angle)
        
        // position scroll view
        let width: CGFloat = fabs(cos(self.angle)) * self.cropView.frame.size.width + fabs(sin(self.angle)) * self.cropView.frame.size.height
        let height: CGFloat = fabs(sin(self.angle)) * self.cropView.frame.size.width + fabs(cos(self.angle)) * self.cropView.frame.size.height
        let center: CGPoint = self.scrollView.center
        let contentOffset: CGPoint = self.scrollView.contentOffset
        let contentOffsetCenter = CGPoint(x: (contentOffset.x + self.scrollView.bounds.size.width / 2.0),
                                          y: (contentOffset.y + self.scrollView.bounds.size.height / 2.0))
        self.scrollView.bounds = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        let newContentOffset = CGPoint(x: (contentOffsetCenter.x - self.scrollView.bounds.size.width / 2.0),
                                       y: (contentOffsetCenter.y - self.scrollView.bounds.size.height / 2.0))
        self.scrollView.contentOffset = newContentOffset
        self.scrollView.center = center
        
        // scale scroll view
        let shouldScale: Bool = self.scrollView.contentSize.width / self.scrollView.bounds.size.width <= 1.0 ||
                                self.scrollView.contentSize.height / self.scrollView.bounds.size.height <= 1.0
        if !self.manualZoomed || shouldScale {
            let zoom = self.scrollView.zoomScaleToBound()
            self.scrollView.setZoomScale(zoom, animated: false)
            self.scrollView.minimumZoomScale = zoom
            self.manualZoomed = false
        }
        self.checkScrollViewContentOffset()
    }
    
    open func stopChangeAngel() {
        self.cropView.dismissGridLines()
    }
    
    open func resetView() {
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            self.angle = 0
            self.scrollView.transform = CGAffineTransform.identity
            self.scrollView.center = CGPoint(x: (self.frame.width / 2.0), y: self.centerY)
            self.scrollView.bounds = CGRect(x: 0.0,
                                            y: 0.0,
                                            width: self.originalSize.width,
                                            height: self.originalSize.height)
            self.scrollView.minimumZoomScale = 1
            self.scrollView.setZoomScale(1, animated: false)
            
            self.cropView.frame = self.scrollView.frame
            self.cropView.center = self.scrollView.center
            self.updateMasks(false)
        })
    }
}

extension IGRPhotoTweakView : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoContentView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.cropView.updateCropLines(true)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.manualZoomed = true
        self.cropView.dismissCropLines()
    }
}

extension IGRPhotoTweakView : IGRPhotoScrollViewDelegate {
    func scrollViewDidStartUpdateScrollContentOffset(_ scrollView: UIScrollView) {
        self.highlightMask(true, animate: true)
    }
    
    func scrollViewDidStopScrollUpdateContentOffset(_ scrollView: UIScrollView) {
        self.highlightMask(false, animate: true)
    }
}

extension IGRPhotoTweakView : IGRCropViewDelegate {
    
    func cropViewDidStartCrop(_ cropView: IGRCropView) {
        self.highlightMask(true, animate: true)
    }
    
    func cropViewDidMove(_ cropView: IGRCropView) {
        self.updateMasks(false)
    }
    
    func cropViewDidStopCrop(_ cropView: IGRCropView) {
        let scaleX: CGFloat = self.originalSize.width / cropView.bounds.size.width
        let scaleY: CGFloat = self.originalSize.height / cropView.bounds.size.height
        let scale: CGFloat = min(scaleX, scaleY)
        // calculate the new bounds of crop view
        let newCropBounds = CGRect(x: 0.0,
                                   y: 0.0,
                                   width: (scale * cropView.frame.size.width),
                                   height: (scale * cropView.frame.size.height))
        // calculate the new bounds of scroll view
        let width: CGFloat = fabs(cos(self.angle)) * newCropBounds.size.width + fabs(sin(self.angle)) * newCropBounds.size.height
        let height: CGFloat = fabs(sin(self.angle)) * newCropBounds.size.width + fabs(cos(self.angle)) * newCropBounds.size.height
        // calculate the zoom area of scroll view
        var scaleFrame: CGRect = cropView.frame
        if scaleFrame.size.width >= self.scrollView.bounds.size.width {
            scaleFrame.size.width = self.scrollView.bounds.size.width - 1
        }
        if scaleFrame.size.height >= self.scrollView.bounds.size.height {
            scaleFrame.size.height = self.scrollView.bounds.size.height - 1
        }
        
        let contentOffset: CGPoint = self.scrollView.contentOffset
        let contentOffsetCenter = CGPoint(x: (contentOffset.x + self.scrollView.bounds.size.width / 2.0),
                                          y: (contentOffset.y + self.scrollView.bounds.size.height / 2.0))
        var bounds: CGRect = self.scrollView.bounds
        bounds.size.width = width
        bounds.size.height = height
        self.scrollView.bounds = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        let newContentOffset = CGPoint(x: (contentOffsetCenter.x - self.scrollView.bounds.size.width / 2.0),
                                       y: (contentOffsetCenter.y - self.scrollView.bounds.size.height / 2.0))
        self.scrollView.contentOffset = newContentOffset
        
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            // animate crop view
            cropView.bounds = CGRect(x: 0.0,
                                     y: 0.0,
                                     width: (newCropBounds.size.width),
                                     height: (newCropBounds.size.height))
            cropView.center = CGPoint(x: (self.frame.width / 2.0), y: self.centerY)
            
            // zoom the specified area of scroll view
            let zoomRect: CGRect = self.convert(scaleFrame, to: self.scrollView.photoContentView)
            self.scrollView.zoom(to: zoomRect, animated: false)
        })
        
        self.manualZoomed = true
        // update masks
        self.updateMasks(true)
        self.cropView.dismissCropLines()
        self.cropView.dismissGridLines()
        let scaleH: CGFloat = self.scrollView.bounds.size.height / self.scrollView.contentSize.height
        let scaleW: CGFloat = self.scrollView.bounds.size.width / self.scrollView.contentSize.width
        var scaleM: CGFloat = max(scaleH, scaleW)
        let duration = 0.2
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {() -> Void in
            if scaleM > 1 {
                scaleM = scaleM * self.scrollView.zoomScale
                self.scrollView.setZoomScale(scaleM, animated: false)
            }
            UIView.animate(withDuration: duration, animations: {() -> Void in
                self.checkScrollViewContentOffset()
            })
        })
        
        self.highlightMask(false, animate: true)
    }
}
