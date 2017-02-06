//
//  IGRPhotoTweakView.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

class IGRPhotoTweakView: UIView {
    private(set) var angle: CGFloat = 0.0
    private(set) var photoContentOffset = CGPoint.zero
    private(set) var cropView: IGRCropView!
    private(set) var photoContentView: IGRPhotoContentView!
    private(set) var slider: UISlider!
    private(set) var resetBtn: UIButton!
    var photoTranslation: CGPoint {
        get {
            let rect: CGRect = self.photoContentView.convert(self.photoContentView.bounds, to: self)
            let point = CGPoint(x: CGFloat(rect.origin.x + rect.size.width / 2), y: CGFloat(rect.origin.y + rect.size.height / 2))
            let zeroPoint = CGPoint(x: CGFloat(self.frame.width / 2), y: CGFloat(self.centerY))
            return CGPoint(x: CGFloat(point.x - zeroPoint.x), y: CGFloat(point.y - zeroPoint.y))
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
    fileprivate var maxRotationAngle = kMaxRotationAngle
    
    init(frame: CGRect, image: UIImage, maxRotationAngle: CGFloat) {
        super.init(frame: frame)
    
        self.image = image
        self.maxRotationAngle = maxRotationAngle
        // scale the image
        self.maximumCanvasSize = CGSize(width: CGFloat(kMaximumCanvasWidthRatio * self.frame.size.width), height: CGFloat(kMaximumCanvasHeightRatio * self.frame.size.height - kCanvasHeaderHeigth))
        let scaleX: CGFloat = image.size.width / self.maximumCanvasSize.width
        let scaleY: CGFloat = image.size.height / self.maximumCanvasSize.height
        let scale: CGFloat = max(scaleX, scaleY)
        let bounds = CGRect(x: CGFloat(0),
                            y: CGFloat(0),
                            width: CGFloat(image.size.width / scale),
                            height: CGFloat(image.size.height / scale))
        self.originalSize = bounds.size
        self.centerY = self.maximumCanvasSize.height / 2 + kCanvasHeaderHeigth
        self.scrollView = IGRPhotoScrollView(frame: bounds)
        self.scrollView.center = CGPoint(x: CGFloat(self.frame.width / 2), y: CGFloat(self.centerY))
        self.scrollView.bounces = true
        self.scrollView.layer.anchorPoint = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.alwaysBounceHorizontal = true
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1
        self.scrollView.maximumZoomScale = 10
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.clipsToBounds = false
        self.scrollView.contentSize = CGSize(width: CGFloat(self.scrollView.bounds.size.width), height: CGFloat(self.scrollView.bounds.size.height))
        self.addSubview(self.scrollView)
#if kInstruction
            self.scrollView.layer.borderColor = UIColor.red.cgColor
            self.scrollView.layer.borderWidth = 1
            self.scrollView.showsVerticalScrollIndicator = true
            self.scrollView.showsHorizontalScrollIndicator = true
#endif
        self.photoContentView = IGRPhotoContentView(frame: self.scrollView.bounds)
        self.photoContentView.image = image
        self.photoContentView.backgroundColor = UIColor.clear
        self.photoContentView.isUserInteractionEnabled = true
        
        self.scrollView.photoContentView = self.photoContentView
        self.scrollView.addSubview(self.photoContentView)
        
        self.cropView = IGRCropView(frame: self.scrollView.frame)
        self.cropView.center = self.scrollView.center
        self.cropView.delegate = self
        self.addSubview(self.cropView)
        
        let maskColor = UIColor.mask()
        self.topMask = UIView()
        self.topMask.backgroundColor = maskColor
        self.addSubview(self.topMask)
        
        self.leftMask = UIView()
        self.leftMask.backgroundColor = maskColor
        self.addSubview(self.leftMask)
        
        self.bottomMask = UIView()
        self.bottomMask.backgroundColor = maskColor
        self.addSubview(self.bottomMask)
        
        self.rightMask = UIView()
        self.rightMask.backgroundColor = maskColor
        self.addSubview(self.rightMask)
        self.updateMasks(false)
        
        self.slider = UISlider(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(260), height: CGFloat(20)))
        self.slider.center = CGPoint(x: CGFloat(self.bounds.width / 2), y: CGFloat(self.bounds.height - 135))
        self.slider.minimumValue = -(Float)(self.maxRotationAngle)
        self.slider.maximumValue = Float(self.maxRotationAngle)
        self.slider.addTarget(self, action: #selector(self.sliderValueChanged), for: .valueChanged)
        self.slider.addTarget(self, action: #selector(self.sliderTouchEnded), for: .touchUpInside)
        self.addSubview(self.slider)
        
        self.resetBtn = UIButton(type: .custom)
        self.resetBtn.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(60), height: CGFloat(20))
        self.resetBtn.center = CGPoint(x: CGFloat(self.bounds.width / 2), y: CGFloat(self.bounds.height - 95))
        self.resetBtn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(14))
        self.resetBtn.setTitleColor(UIColor.resetButton(), for: .normal)
        self.resetBtn.setTitleColor(UIColor.resetButtonHighlighted(), for: .highlighted)
        self.resetBtn.setTitle("RESET", for: .normal)
        self.resetBtn.addTarget(self, action: #selector(self.resetBtnTapped), for: .touchUpInside)
        self.addSubview(self.resetBtn)
        self.originalPoint = self.convert(self.scrollView.center, to: self)
    }
    
    convenience init(frame: CGRect, image: UIImage) {
        self.init(frame: frame, image: image, maxRotationAngle: kMaxRotationAngle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.slider.frame.contains(point) {
            return self.slider
        }
        else if self.resetBtn.frame.contains(point) {
            return self.resetBtn
        }
        else if self.cropView.frame.insetBy(dx: CGFloat(-kCropViewHotArea), dy: CGFloat(-kCropViewHotArea)).contains(point) && !self.cropView.frame.insetBy(dx: CGFloat(kCropViewHotArea), dy: CGFloat(kCropViewHotArea)).contains(point) {
            return self.cropView
        }
        
        return self.scrollView
    }
    
    func updateMasks(_ animate: Bool) {
        let animationBlock: ((_: Void) -> Void)? = {(_: Void) -> Void in
            self.topMask.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.cropView.frame.origin.x + self.cropView.frame.size.width), height: CGFloat(self.cropView.frame.origin.y))
            self.leftMask.frame = CGRect(x: CGFloat(0), y: CGFloat(self.cropView.frame.origin.y), width: CGFloat(self.cropView.frame.origin.x), height: CGFloat(self.frame.size.height - self.cropView.frame.origin.y))
            self.bottomMask.frame = CGRect(x: CGFloat(self.cropView.frame.origin.x), y: CGFloat(self.cropView.frame.origin.y + self.cropView.frame.size.height), width: CGFloat(self.frame.size.width - self.cropView.frame.origin.x), height: CGFloat(self.frame.size.height - (self.cropView.frame.origin.y + self.cropView.frame.size.height)))
            self.rightMask.frame = CGRect(x: CGFloat(self.cropView.frame.origin.x + self.cropView.frame.size.width), y: CGFloat(0), width: CGFloat(self.frame.size.width - (self.cropView.frame.origin.x + self.cropView.frame.size.width)), height: CGFloat(self.cropView.frame.origin.y + self.cropView.frame.size.height))
        }
        if animate {
            UIView.animate(withDuration: 0.25, animations: animationBlock!)
        }
        else {
            animationBlock!()
        }
    }
    
    func checkScrollViewContentOffset() {
        self.scrollView.contentOffset.x = max(self.scrollView.contentOffset.x, 0)
        self.scrollView.contentOffset.y = max(self.scrollView.contentOffset.y, 0)
        if self.scrollView.contentSize.height - self.scrollView.contentOffset.y <= self.scrollView.bounds.size.height {
            self.scrollView.contentOffset.y = self.scrollView.contentSize.height - self.scrollView.bounds.size.height
        }
        if self.scrollView.contentSize.width - self.scrollView.contentOffset.x <= self.scrollView.bounds.size.width {
            self.scrollView.contentOffset.x = self.scrollView.contentSize.width - self.scrollView.bounds.size.width
        }
    }
    
    func sliderValueChanged(_ sender: Any) {
        // update masks
        self.updateMasks(false)
        // update grids
        self.cropView.updateGridLines(false)
        // rotate scroll view
        self.angle = CGFloat(self.slider.value)
        self.scrollView.transform = CGAffineTransform(rotationAngle: self.angle)
        // position scroll view
        let width: CGFloat = fabs(cos(self.angle)) * self.cropView.frame.size.width + fabs(sin(self.angle)) * self.cropView.frame.size.height
        let height: CGFloat = fabs(sin(self.angle)) * self.cropView.frame.size.width + fabs(cos(self.angle)) * self.cropView.frame.size.height
        let center: CGPoint = self.scrollView.center
        let contentOffset: CGPoint = self.scrollView.contentOffset
        let contentOffsetCenter = CGPoint(x: CGFloat(contentOffset.x + self.scrollView.bounds.size.width / 2), y: CGFloat(contentOffset.y + self.scrollView.bounds.size.height / 2))
        self.scrollView.bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: width, height: height)
        let newContentOffset = CGPoint(x: CGFloat(contentOffsetCenter.x - self.scrollView.bounds.size.width / 2), y: CGFloat(contentOffsetCenter.y - self.scrollView.bounds.size.height / 2))
        self.scrollView.contentOffset = newContentOffset
        self.scrollView.center = center
        // scale scroll view
        let shouldScale: Bool = self.scrollView.contentSize.width / self.scrollView.bounds.size.width <= 1.0 || self.scrollView.contentSize.height / self.scrollView.bounds.size.height <= 1.0
        if !self.manualZoomed || shouldScale {
            self.scrollView.setZoomScale(self.scrollView.zoomScaleToBound(), animated: false)
            self.scrollView.minimumZoomScale = self.scrollView.zoomScaleToBound()
            self.manualZoomed = false
        }
        self.checkScrollViewContentOffset()
    }
    
    func sliderTouchEnded(_ sender: Any) {
        self.cropView.dismissGridLines()
    }
    
    func resetBtnTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            self.angle = 0
            self.scrollView.transform = CGAffineTransform.identity
            self.scrollView.center = CGPoint(x: CGFloat(self.frame.width / 2), y: CGFloat(self.centerY))
            self.scrollView.bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.originalSize.width), height: CGFloat(self.originalSize.height))
            self.scrollView.minimumZoomScale = 1
            self.scrollView.setZoomScale(1, animated: false)
            self.cropView.frame = self.scrollView.frame
            self.cropView.center = self.scrollView.center
            self.updateMasks(false)
            self.slider.setValue(0, animated: true)
        })
    }
}

extension IGRPhotoTweakView : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoContentView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.manualZoomed = true
    }
}

extension IGRPhotoTweakView : IGRCropViewDelegate {
    
    func cropEnded(_ cropView: IGRCropView) {
        let scaleX: CGFloat = self.originalSize.width / cropView.bounds.size.width
        let scaleY: CGFloat = self.originalSize.height / cropView.bounds.size.height
        let scale: CGFloat = min(scaleX, scaleY)
        // calculate the new bounds of crop view
        let newCropBounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(scale * cropView.frame.size.width), height: CGFloat(scale * cropView.frame.size.height))
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
        let contentOffsetCenter = CGPoint(x: CGFloat(contentOffset.x + self.scrollView.bounds.size.width / 2), y: CGFloat(contentOffset.y + self.scrollView.bounds.size.height / 2))
        var bounds: CGRect = self.scrollView.bounds
        bounds.size.width = width
        bounds.size.height = height
        self.scrollView.bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(width), height: CGFloat(height))
        let newContentOffset = CGPoint(x: CGFloat(contentOffsetCenter.x - self.scrollView.bounds.size.width / 2), y: CGFloat(contentOffsetCenter.y - self.scrollView.bounds.size.height / 2))
        self.scrollView.contentOffset = newContentOffset
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            // animate crop view
            cropView.bounds = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(newCropBounds.size.width), height: CGFloat(newCropBounds.size.height))
            cropView.center = CGPoint(x: CGFloat(self.frame.width / 2), y: CGFloat(self.centerY))
            // zoom the specified area of scroll view
            let zoomRect: CGRect = self.convert(scaleFrame, to: self.scrollView.photoContentView)
            self.scrollView.zoom(to: zoomRect, animated: false)
        })
        
        self.manualZoomed = true
        // update masks
        self.updateMasks(true)
        self.cropView.dismissCropLines()
        let scaleH: CGFloat = self.scrollView.bounds.size.height / self.scrollView.contentSize.height
        let scaleW: CGFloat = self.scrollView.bounds.size.width / self.scrollView.contentSize.width
        var scaleM: CGFloat = max(scaleH, scaleW)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
            if scaleM > 1 {
                scaleM = scaleM * self.scrollView.zoomScale
                self.scrollView.setZoomScale(scaleM, animated: false)
            }
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                self.checkScrollViewContentOffset()
            })
        })
    }
    
    func cropMoved(_ cropView: IGRCropView) {
        self.updateMasks(false)
    }
}
