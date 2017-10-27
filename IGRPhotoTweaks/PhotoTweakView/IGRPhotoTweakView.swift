//
//  IGRPhotoTweakView.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

public class IGRPhotoTweakView: UIView {
    
    //MARK: - Public VARs
    
    public weak var customizationDelegate: IGRPhotoTweakViewCustomizationDelegate?
    
    private(set) lazy var cropView: IGRCropView! = { [unowned self] by in
        
        let cropView = IGRCropView(frame: self.scrollView.frame,
                                    cornerBorderWidth:self.cornerBorderWidth(),
                                    cornerBorderLength:self.cornerBorderLength())
        cropView.center = self.scrollView.center
        
        cropView.layer.borderColor = self.borderColor().cgColor
        cropView.layer.borderWidth = self.borderWidth()
        self.addSubview(cropView)
        
        return cropView
    }(())
    
    private(set) lazy var photoContentView: IGRPhotoContentView! = { [unowned self] by in
        
        let photoContentView = IGRPhotoContentView(frame: self.scrollView.bounds)
        photoContentView.isUserInteractionEnabled = true
        self.scrollView.addSubview(photoContentView)
        
        return photoContentView
    }(())
    
    public var photoTranslation: CGPoint {
        get {
            let rect: CGRect = self.photoContentView.convert(self.photoContentView.bounds,
                                                             to: self)
            let point = CGPoint(x: (rect.origin.x + rect.size.width.half),
                                y: (rect.origin.y + rect.size.height.half))
            let zeroPoint = CGPoint(x: self.frame.width.half, y: self.centerY)
            
            return CGPoint(x: (point.x - zeroPoint.x), y: (point.y - zeroPoint.y))
        }
    }
    
    //MARK: - Private VARs
    
    internal var angle: CGFloat         = CGFloat.zero
    fileprivate var photoContentOffset  = CGPoint.zero
    
    internal lazy var scrollView: IGRPhotoScrollView! = { [unowned self] by in
        
        let maxBounds = self.maxBounds()
        self.originalSize = maxBounds.size
        
        let scrollView = IGRPhotoScrollView(frame: maxBounds)
        scrollView.center = CGPoint(x: self.frame.width.half, y: self.centerY)
        scrollView.delegate = self
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(scrollView)
        
        return scrollView
    }(())
    
    internal weak var image: UIImage!
    internal var originalSize = CGSize.zero
    
    internal var manualZoomed = false
    internal var manualMove   = false
    
    // masks
    internal var topMask:    IGRCropMaskView!
    internal var leftMask:   IGRCropMaskView!
    internal var bottomMask: IGRCropMaskView!
    internal var rightMask:  IGRCropMaskView!
    
    // constants
    fileprivate var maximumCanvasSize: CGSize!
    fileprivate var originalPoint: CGPoint!
    internal var centerY: CGFloat!
    
    // MARK: - Life Cicle
    
    init(frame: CGRect, image: UIImage, customizationDelegate: IGRPhotoTweakViewCustomizationDelegate!) {
        super.init(frame: frame)
        
        self.image = image
        
        self.customizationDelegate = customizationDelegate
        
        setupScrollView()
        setupCropView()
        setupMasks()
        
        self.originalPoint = self.convert(self.scrollView.center, to: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.originalSize = self.maxBounds().size
    }
    
    //MARK: - Public FUNCs

    public func resetView() {
        UIView.animate(withDuration: kAnimationDuration, animations: {() -> Void in
            self.angle = 0
            self.scrollView.transform = CGAffineTransform.identity
            self.scrollView.center = CGPoint(x: self.frame.width.half, y: self.centerY)
            self.scrollView.bounds = CGRect(x: CGFloat.zero,
                                            y: CGFloat.zero,
                                            width: self.originalSize.width,
                                            height: self.originalSize.height)
            self.scrollView.minimumZoomScale = 1
            self.scrollView.setZoomScale(1, animated: false)
            
            self.cropView.frame = self.scrollView.frame
            self.cropView.center = self.scrollView.center
        })
    }
    
    public func applyDeviceRotation() {
        self.scrollView.center = CGPoint(x: self.frame.width.half, y: self.centerY)
        self.scrollView.bounds = CGRect(x: CGFloat.zero,
                                        y: CGFloat.zero,
                                        width: self.originalSize.width,
                                        height: self.originalSize.height)
        
        self.cropView.frame = self.scrollView.frame
        self.cropView.center = self.scrollView.center
        
        updatePosition()
    }
    
    //MARK: - Private FUNCs
    
    fileprivate func maxBounds() -> CGRect {
        // scale the image
        self.maximumCanvasSize = CGSize(width: (kMaximumCanvasWidthRatio * self.frame.size.width),
                                        height: (kMaximumCanvasHeightRatio * self.frame.size.height - self.canvasHeaderHeigth()))
        
        self.centerY = self.maximumCanvasSize.height.half + self.canvasHeaderHeigth()
        
        let scaleX: CGFloat = self.image.size.width / self.maximumCanvasSize.width
        let scaleY: CGFloat = self.image.size.height / self.maximumCanvasSize.height
        let scale: CGFloat = max(scaleX, scaleY)
        
        let bounds = CGRect(x: CGFloat.zero,
                            y: CGFloat.zero,
                            width: (self.image.size.width / scale),
                            height: (self.image.size.height / scale))
        
        return bounds
    }
    
    internal func updatePosition() {
        // position scroll view
        let width: CGFloat = fabs(cos(self.angle)) * self.cropView.frame.size.width + fabs(sin(self.angle)) * self.cropView.frame.size.height
        let height: CGFloat = fabs(sin(self.angle)) * self.cropView.frame.size.width + fabs(cos(self.angle)) * self.cropView.frame.size.height
        let center: CGPoint = self.scrollView.center
        let contentOffset: CGPoint = self.scrollView.contentOffset
        let contentOffsetCenter = CGPoint(x: (contentOffset.x + self.scrollView.bounds.size.width.half),
                                          y: (contentOffset.y + self.scrollView.bounds.size.height.half))
        self.scrollView.bounds = CGRect(x: CGFloat.zero, y: CGFloat.zero, width: width, height: height)
        let newContentOffset = CGPoint(x: (contentOffsetCenter.x - self.scrollView.bounds.size.width.half),
                                       y: (contentOffsetCenter.y - self.scrollView.bounds.size.height.half))
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
        
        self.scrollView.checkContentOffset()
    }
}
