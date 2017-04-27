//
//  IGRPhotoTweakViewController.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit


@objc public protocol IGRPhotoTweakViewControllerDelegate: NSObjectProtocol {
    
    /**
     Called on image cropped.
     */
    @objc func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage)
    /**
     Called on cropping image canceled
     */
    
    @objc func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController)
}

@objc(IGRPhotoTweakViewController) open class IGRPhotoTweakViewController: UIViewController {
    
    //MARK: - Public VARs
    
    /*
     Image to process.
     */
    public var image: UIImage!
    
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
    
    internal lazy var photoView: IGRPhotoTweakView! = { [unowned self] by in
        
        let photoView = IGRPhotoTweakView(frame: self.view.bounds,
                                          image: self.image,
                                          customizationDelegate: self)
        photoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(photoView)
        
        return photoView
        }()
    
    // MARK: - Life Cicle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
        self.setupThemes()
        self.setupSubviews()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupSubviews() {
        self.view.sendSubview(toBack: self.photoView)
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
        self.photoView.resetView()
        self.stopChangeAngle()
    }
    
    public func dismissAction() {
        self.delegate?.photoTweaksControllerDidCancel(self)
    }
    
    public func cropAction() {
        var transform = CGAffineTransform.identity
        // translate
        let translation: CGPoint = self.photoView.photoTranslation
        transform = transform.translatedBy(x: translation.x, y: translation.y)
        // rotate
        transform = transform.rotated(by: self.photoView.angle)
        // scale
        
        let t: CGAffineTransform = self.photoView.photoContentView.transform
        let xScale: CGFloat = sqrt(t.a * t.a + t.c * t.c)
        let yScale: CGFloat = sqrt(t.b * t.b + t.d * t.d)
        transform = transform.scaledBy(x: xScale, y: yScale)
        
        if let fixedImage = self.image.cgImageWithFixedOrientation() {
            let imageRef = fixedImage.transformedImage(transform,
                                                       sourceSize: self.image.size,
                                                       outputWidth: self.image.size.width,
                                                       cropSize: self.photoView.cropView.frame.size,
                                                       imageViewSize: self.photoView.photoContentView.bounds.size)
            
            let image = UIImage(cgImage: imageRef)
            
            if self.isAutoSaveToLibray {
                
                self.saveToLibrary(image: image)
            }
<<<<<<< HEAD
        }
        self.delegate?.photoTweaksController(self, didFinishWithCroppedImage: image)
    }
    public func lockAspectRatio(isLock:Bool) {
        self.photoView.lockAspectRatio(isLocked: isLock)
    }
    public func resetAspectRect() {
        self.photoView.resetAspectRect()
    }
    
    public func setCropAspectRect(aspect: String) {
        self.photoView.setCropAspectRect(aspect: aspect)
    }
    
    // MARK: - Image Processor
    
    fileprivate func fixOrientation(for image: UIImage) -> CGImage? {
        
        guard let cgImage = image.cgImage, let colorSpace = cgImage.colorSpace else {
            return nil
        }
        
        if image.imageOrientation == UIImageOrientation.up {
            return image.cgImage
        }
        
        let width  = image.size.width
        let height = image.size.height
        
        var transform = CGAffineTransform.identity
        
        switch image.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: width, y: height)
            transform = transform.rotated(by: CGFloat.pi)
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.rotated(by: 0.5 * CGFloat.pi)
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: height)
            transform = transform.rotated(by: -0.5 * CGFloat.pi)
            
        case .up, .upMirrored:
            break
        }
        
        switch image.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        default:
            break
        }
        
        guard let context = CGContext(
            data: nil,
            width: Int(width),
            height: Int(height),
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: UInt32(cgImage.bitmapInfo.rawValue)
            ) else {
                return nil
        }
        
        context.concatenate(transform)
        
        switch image.imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                context.draw(cgImage, in: CGRect(x: 0, y: 0, width: height, height: width))
=======
>>>>>>> IGRSoft/master
            
            self.delegate?.photoTweaksController(self, didFinishWithCroppedImage: image)
        }
    }
}
