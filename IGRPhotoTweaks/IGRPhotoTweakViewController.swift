//
//  IGRPhotoTweakViewController.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit
import Photos


@objc public protocol IGRPhotoTweakViewControllerDelegate: NSObjectProtocol {
    
    /**
     Called on image cropped.
     */
    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage)
    /**
     Called on cropping image canceled
     */
    
    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController)
}

@objc(IGRPhotoTweakViewController) open class IGRPhotoTweakViewController: UIViewController {
    
    //MARK: - Public VARs
    
    /*
     Image to process.
     */
    open var image: UIImage!
    
    /*
     The optional photo tweaks controller delegate.
     */
    open weak var delegate: IGRPhotoTweakViewControllerDelegate?
    
    //MARK: - Protected VARs
    
    /*
     Flag indicating whether the image cropped will be saved to photo library automatically. Defaults to YES.
     */
    internal var isAutoSaveToLibray: Bool = false
    
    //MARK: - Private VARs
    
    fileprivate var photoView: IGRPhotoTweakView!
    
    fileprivate let kBitsPerComponent = 8
    fileprivate let kBitmapBytesPerRow = 0
    
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
        self.photoView = IGRPhotoTweakView(frame: self.view.bounds,
                                           image: self.image,
                                           customizationDelegate: self)
        self.photoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(self.photoView)
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
    
    open func changedAngle(value: CGFloat) {
        self.photoView.changedAngle(value: value)
    }
    
    open func stopChangeAngle() {
        self.photoView.stopChangeAngle()
    }
    
    open func resetView() {
        self.photoView.resetView()
        self.stopChangeAngle()
    }
    
    open func dismissAction() {
        self.delegate?.photoTweaksControllerDidCancel(self)
    }
    
    open func cropAction() {
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
        
        let fixedImage = fixOrientation(imageToFix: self.image)
        
        let imageRef: CGImage = self.newTransformedImage(transform, sourceImage: fixedImage!, sourceSize: self.image.size, outputWidth: self.image.size.width, cropSize: self.photoView.cropView.frame.size, imageViewSize: self.photoView.photoContentView.bounds.size)
        
        let image = UIImage(cgImage: imageRef)
        
        if self.isAutoSaveToLibray {
            
            let writePhotoToLibraryBlock: ((_: Void) -> Void)? = {(_: Void) -> Void in
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
            }
            
            if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
                writePhotoToLibraryBlock!()
            }
            else {
                PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
                    if status == PHAuthorizationStatus.authorized {
                        DispatchQueue.main.async{
                            writePhotoToLibraryBlock!()
                        }
                    }
                    else {
                        DispatchQueue.main.async{
                            let ac = UIAlertController(title: "Authorization error",
                                                       message: "App don't granted to access to Photo Library",
                                                       preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            ac.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
                                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                                    return
                                }
                                
                                if UIApplication.shared.canOpenURL(settingsUrl) {
                                    if #available(iOS 10.0, *) {
                                        UIApplication.shared.open(settingsUrl)
                                    } else {
                                        UIApplication.shared.openURL(settingsUrl)
                                    }
                                }
                            }))
                            self.present(ac, animated: true, completion: nil)
                        }
                    }
                })
            }
        }
        self.delegate?.photoTweaksController(self, didFinishWithCroppedImage: image)
    }
    
    open func resetAspectRect() {
        self.photoView.resetAspectRect()
    }
    
    open func setCropAspectRect(aspect: String) {
        self.photoView.setCropAspectRect(aspect: aspect)
    }
    
    // MARK: - Image Processor
    
    fileprivate func fixOrientation(imageToFix: UIImage) -> CGImage? {
        
        guard let cgImage = imageToFix.cgImage else {
            return nil
        }
        
        if imageToFix.imageOrientation == UIImageOrientation.up {
            return imageToFix.cgImage
        }
        
        let width  = imageToFix.size.width
        let height = imageToFix.size.height
        
        var transform = CGAffineTransform.identity
        
        switch imageToFix.imageOrientation {
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
        
        switch imageToFix.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        default:
            break;
        }
        
        
        guard let colorSpace = cgImage.colorSpace else {
            return nil
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
        
        context.concatenate(transform);
        
        switch imageToFix.imageOrientation {
            
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: height, height: width))
            
        default:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        // And now we just create a new UIImage from the drawing context
        guard let newCGImg = context.makeImage() else {
            return nil
        }
        
        return newCGImg
    }
    
    
    fileprivate func newTransformedImage(_ transform: CGAffineTransform, sourceImage: CGImage, sourceSize: CGSize, outputWidth: CGFloat, cropSize: CGSize, imageViewSize: CGSize) -> CGImage {
        
        let aspect: CGFloat = cropSize.height / cropSize.width
        let outputSize = CGSize(width: outputWidth, height: (outputWidth * aspect))
        
        let context = CGContext(data: nil,
                                width: Int(outputSize.width),
                                height: Int(outputSize.height),
                                bitsPerComponent: sourceImage.bitsPerComponent,
                                bytesPerRow: kBitmapBytesPerRow,
                                space: sourceImage.colorSpace!,
                                bitmapInfo: sourceImage.bitmapInfo.rawValue)
        context?.setFillColor(UIColor.clear.cgColor)
        context?.fill(CGRect(x: 0.0, y: 0.0, width: (outputSize.width), height: (outputSize.height)))
        var uiCoords = CGAffineTransform(scaleX: outputSize.width / cropSize.width,
                                         y: outputSize.height / cropSize.height)
        uiCoords = uiCoords.translatedBy(x: cropSize.width / 2.0, y: cropSize.height / 2.0)
        uiCoords = uiCoords.scaledBy(x: 1.0, y: -1.0)
        context?.concatenate(uiCoords)
        context?.concatenate(transform)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.draw(sourceImage, in: CGRect(x: (-imageViewSize.width / 2.0),
                                              y: (-imageViewSize.height / 2.0),
                                              width: imageViewSize.width,
                                              height: imageViewSize.height))
        
        let resultRef: CGImage = context!.makeImage()!
        
        return resultRef
    }
    
    internal func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            let ac = UIAlertController(title: "Save error",
                                       message: error?.localizedDescription,
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK",
                                       style: .default,
                                       handler: nil))
            present(ac, animated: true, completion: nil)
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
    
    open func customIsHighlightMask() -> Bool {
        return true
    }
    
    open func customHighlightMaskAlphaValue() -> CGFloat {
        return 0.3
    }
    
    open func customCanvasHeaderHeigth() -> CGFloat {
        return kCanvasHeaderHeigth
    }
}


//MARK: - Delegats funcs

extension IGRPhotoTweakViewController : IGRPhotoTweakViewCustomizationDelegate {
    public func borderColor() -> UIColor {
        return self.customBorderColor()
    }
    
    public func borderWidth() -> CGFloat {
        return self.customBorderWidth()
    }
    
    public func cornerBorderWidth() -> CGFloat {
        return self.customCornerBorderWidth()
    }
    
    public func cornerBorderLength() -> CGFloat {
        return self.customCornerBorderLength()
    }
    
    public func isHighlightMask() -> Bool {
        return self.customIsHighlightMask()
    }
    
    public func highlightMaskAlphaValue() -> CGFloat {
        return self.customHighlightMaskAlphaValue()
    }
    
    public func canvasHeaderHeigth() -> CGFloat {
        return self.customCanvasHeaderHeigth()
    }
}
