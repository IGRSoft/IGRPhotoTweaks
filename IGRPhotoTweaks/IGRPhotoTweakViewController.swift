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

@objc open class IGRPhotoTweakViewController: UIViewController {
    
    /**
     Image to process.
     */
    open var image: UIImage!
    /**
     Flag indicating whether the image cropped will be saved to photo library automatically. Defaults to YES.
     */
    internal var isAutoSaveToLibray: Bool = false

    /**
     The optional photo tweaks controller delegate.
     */
    open weak var delegate: IGRPhotoTweakViewControllerDelegate?
    
    fileprivate var photoView: IGRPhotoTweakView!;
    
    fileprivate let kBitsPerComponent = 8
    fileprivate let kBitmapBytesPerRow = 0
    
    // MARK: - Life Cicle
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        
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
    
    // MARK: - Public
    
    open func changedAngel(value: CGFloat) {
        self.photoView.changedAngel(value: value)
    }
    
    open func stopChangeAngel() {
        self.photoView.stopChangeAngel()
    }
    
    open func resetView() {
        self.photoView.resetView()
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
        let imageRef: CGImage = self.newTransformedImage(transform, sourceImage: self.image.cgImage!, sourceSize: self.image.size, sourceOrientation: self.image.imageOrientation, outputWidth: self.image.size.width, cropSize: self.photoView.cropView.frame.size, imageViewSize: self.photoView.photoContentView.bounds.size)
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
                            let ac = UIAlertController(title: "Authorization error", message: "App don't granted to access to Photo Library", preferredStyle: .alert)
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
    
    fileprivate func newScaledImage(_ source: CGImage, with orientation: UIImageOrientation, to size: CGSize, with quality: CGInterpolationQuality) -> CGImage {
        var srcSize: CGSize = size
        var rotation: CGFloat = 0.0
        switch orientation {
        case .up:
            rotation = 0
        case .down:
            rotation = .pi
        case .left:
            rotation = CGFloat(M_PI_2)
            srcSize = CGSize(width: size.height, height: size.width)
        case .right:
            rotation = -(CGFloat)(M_PI_2)
            srcSize = CGSize(width: size.height, height: size.width)
        default:
            break
        }
        
        let rgbColorSpace: CGColorSpace? = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo: CGBitmapInfo!
        if #available(iOS 10.0, *) {
            bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGImageByteOrderInfo.order32Big.rawValue)
        } else {
            bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | (4 << 12))
        }
        
        let context = CGContext(data: nil,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: kBitsPerComponent,
                                bytesPerRow: kBitmapBytesPerRow,
                                space: rgbColorSpace!,
                                bitmapInfo: bitmapInfo.rawValue
        )
        context!.interpolationQuality = quality
        context?.translateBy(x: size.width / 2, y: size.height / 2)
        context?.rotate(by: rotation)
        context?.draw(source, in: CGRect(x: (-srcSize.width / 2.0),
                                         y: (-srcSize.height / 2.0),
                                         width: srcSize.width,
                                         height: srcSize.height))
        let resultRef: CGImage = context!.makeImage()!
        
        return resultRef
    }
    
    fileprivate func newTransformedImage(_ transform: CGAffineTransform, sourceImage: CGImage, sourceSize: CGSize, sourceOrientation: UIImageOrientation, outputWidth: CGFloat, cropSize: CGSize, imageViewSize: CGSize) -> CGImage {
        let source: CGImage = self.newScaledImage(sourceImage, with: sourceOrientation, to: sourceSize, with: .none)
        let aspect: CGFloat = cropSize.height / cropSize.width
        let outputSize = CGSize(width: outputWidth, height: (outputWidth * aspect))
        let context = CGContext(data: nil,
                                width: Int(outputSize.width),
                                height: Int(outputSize.height),
                                bitsPerComponent: source.bitsPerComponent,
                                bytesPerRow: kBitmapBytesPerRow,
                                space: source.colorSpace!,
                                bitmapInfo: source.bitmapInfo.rawValue)
        context?.setFillColor(UIColor.clear.cgColor)
        context?.fill(CGRect(x: 0.0, y: 0.0, width: (outputSize.width), height: (outputSize.height)))
        var uiCoords = CGAffineTransform(scaleX: outputSize.width / cropSize.width, y: outputSize.height / cropSize.height)
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
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
}

extension IGRPhotoTweakViewController : IGRPhotoTweakViewCustomizationDelegate {
    func borderColor() -> UIColor {
        return UIColor.cropLine()
    }
    
    func borderWidth() -> CGFloat {
        return 1.0
    }
    
    func cornerBorderWidth() -> CGFloat {
        return kCropViewCornerWidth
    }
    
    func cornerBorderLength() -> CGFloat {
        return kCropViewCornerLength
    }
}
