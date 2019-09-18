//
//  IGRPhotoTweakViewController.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit


public protocol IGRPhotoTweakViewControllerDelegate : class {
    
    /**
     Called on image cropped.
     */
    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage)
    /**
     Called on cropping image canceled
     */
    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController)
    /**
     Called by cropping change
     */
    func photoTweaksControllerDidChange(_ controller: IGRPhotoTweakViewController)
}

open class IGRPhotoTweakViewController: UIViewController {
    
    //MARK: - Public VARs
    
    /*
     Image to process.
     */
    public var image: UIImage?
    
    /*
     The optional photo tweaks controller delegate.
     */
    public weak var delegate: IGRPhotoTweakViewControllerDelegate?
    
    //MARK: - Protected VARs
    
    /*
     Flag indicating whether the image cropped will be saved to photo library automatically. Defaults to YES.
     */
    internal var isAutoSaveToLibray: Bool = false
    
    //MARK: - Private VARs
    
    public private(set) lazy var photoView: IGRPhotoTweakView? = { [unowned self] by in
        
        let photoView = IGRPhotoTweakView(frame: self.view.bounds,
                                          image: self.image!,
                                          customizationDelegate: self)
        photoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(photoView)
        photoView.transformChangedAction = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.photoTweaksControllerDidChange(strongSelf)
        }
        
        return photoView
        }(())
    
    // MARK: - Life Cicle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        
        self.setupThemes()
        self.setupSubviews()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.photoView?.applyDeviceRotation()
        })
    }
    
    fileprivate func setupSubviews() {
        guard let photoView = self.photoView else {
            return
        }
        self.view.sendSubviewToBack(photoView)
    }
    
    open func setupThemes() {
        IGRPhotoTweakView.appearance().backgroundColor = UIColor.photoTweakCanvasBackground()
        IGRPhotoContentView.appearance().backgroundColor = UIColor.clear
        IGRCropView.appearance().backgroundColor = UIColor.clear
        IGRCropGridLine.appearance().backgroundColor = UIColor.gridLine()
        IGRCropLine.appearance().backgroundColor = UIColor.cropLine()
        IGRCropCornerView.appearance().backgroundColor = UIColor.clear
        IGRCropCornerLine.appearance().backgroundColor = UIColor.cropLine()
        IGRCropMaskView.appearance().backgroundColor = UIColor.mask()
    }
    
    // MARK: - Public
    
    public func resetView() {
        self.photoView?.resetView()
        self.photoView?.stopChangeAngle()
    }
    
    public func dismissAction() {
        self.delegate?.photoTweaksControllerDidCancel(self)
    }

    public var hasChanges: Bool {
        let zoomScale = photoView?.scrollView.zoomScale
        guard zoomScale != 0 else {
            return false
        }
        let sourceSize = image?.size
        let cropSize = photoView?.cropView.frame.size
        let imageViewSize = photoView?.photoContentView.bounds.size
        let expectedWidth = floor(sourceSize!.width / imageViewSize!.width * cropSize!.width) / zoomScale!
        let expectedHeight = floor(sourceSize!.height / imageViewSize!.height * cropSize!.height) / zoomScale!
        guard expectedWidth > 0 && expectedHeight > 0 else {
            return false
        }
        let noChanges = abs((photoView?.photoTranslation.x)!) < 2 && abs(photoView!.photoTranslation.y) < 2
            && abs(photoView!.radians) < 0.0002
            && abs(1 - sourceSize!.width / expectedWidth) < 0.002 && abs(1 - sourceSize!.height / expectedHeight) < 0.002
        return noChanges == false
    }
    
    public func cropAction() {
        guard let photoView = self.photoView,
            let image = image else {
                return
        }
        
        var transform = CGAffineTransform.identity
        // translate
        let translation: CGPoint = photoView.photoTranslation
        transform = transform.translatedBy(x: translation.x, y: translation.y)
        // rotate
        transform = transform.rotated(by: photoView.radians)
        // scale
        
        let t: CGAffineTransform = photoView.photoContentView.transform
        let xScale: CGFloat = sqrt(t.a * t.a + t.c * t.c)
        let yScale: CGFloat = sqrt(t.b * t.b + t.d * t.d)
        transform = transform.scaledBy(x: xScale, y: yScale)
        
        if let fixedImage = image.cgImageWithFixedOrientation() {
            let imageRef = fixedImage.transformedImage(transform,
                                                       zoomScale: photoView.scrollView.zoomScale,
                                                       sourceSize: image.size,
                                                       cropSize: photoView.cropView.frame.size,
                                                       imageViewSize: photoView.photoContentView.bounds.size)
            
            let image = UIImage(cgImage: imageRef!)
            
            if self.isAutoSaveToLibray {
                
                self.saveToLibrary(image: image)
            }
            
            self.delegate?.photoTweaksController(self, didFinishWithCroppedImage: image)
        }
    }
    
    //MARK: - Customization
    
    open func customBorderColor() -> UIColor {
        return UIColor.cropLine()
    }
    
    open func customBorderWidth() -> CGFloat {
        return 1.0
    }
    
    open func customCornerBorderWidth() -> CGFloat {
        return kCropViewCornerWidth
    }
    
    open func customCornerBorderLength() -> CGFloat {
        return kCropViewCornerLength
    }
    
    open func customCropLinesCount() -> Int {
        return kCropLinesCount
    }
    
    open func customGridLinesCount() -> Int {
        return kGridLinesCount
    }
    
    open func customIsHighlightMask() -> Bool {
        return true
    }
    
    open func customHighlightMaskAlphaValue() -> CGFloat {
        return 0.3
    }
    
    open func customCanvasInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: kCanvasHeaderHeigth, left: 0, bottom: 0, right: 0)
    }
}
