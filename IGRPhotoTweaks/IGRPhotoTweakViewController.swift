//
//  IGRPhotoTweakViewController.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

protocol IGRPhotoTweakViewControllerDelegate: NSObjectProtocol {
    /**
     Called on image cropped.
     */
    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage)
    /**
     Called on cropping image canceled
     */
    
    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController)
}

class IGRPhotoTweakViewController: UIViewController {

    /**
     Image to process.
     */
    private(set) var image: UIImage!
    /**
     Flag indicating whether the image cropped will be saved to photo library automatically. Defaults to YES.
     */
    var isAutoSaveToLibray: Bool = false
    /**
     Max rotation angle
     */
    var maxRotationAngle: CGFloat = kMaxRotationAngle
    /**
     The optional photo tweaks controller delegate.
     */
    open weak var delegate: IGRPhotoTweakViewControllerDelegate?
    /**
     Save action button's default title color
     */
    var saveButtonTitleColor: UIColor!
    /**
     Save action button's highlight title color
     */
    var saveButtonHighlightTitleColor: UIColor!
    /**
     Cancel action button's default title color
     */
    var cancelButtonTitleColor: UIColor!
    /**
     Cancel action button's highlight title color
     */
    var cancelButtonHighlightTitleColor: UIColor!
    /**
     Reset action button's default title color
     */
    var resetButtonTitleColor: UIColor!
    /**
     Reset action button's highlight title color
     */
    var resetButtonHighlightTitleColor: UIColor!
    /**
     Slider tint color
     */
    var sliderTintColor: UIColor!
    /**
     Creates a photo tweaks view controller with the image to process.
     */
    
    fileprivate var photoView: IGRPhotoTweakView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.clipsToBounds = true
        self.view.backgroundColor = UIColor.photoTweakCanvasBackground()
        self.setupSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupSubviews() {
        self.photoView = IGRPhotoTweakView(frame: self.view.bounds, image: self.image, maxRotationAngle: self.maxRotationAngle)
        self.photoView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(self.photoView)
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: CGFloat(8), y: CGFloat(self.view.frame.height - 40), width: CGFloat(60), height: CGFloat(40))
        cancelBtn.titleLabel?.textAlignment = .left
        cancelBtn.setTitle("Cancel", for: .normal)
        let cancelTitleColor = !(self.cancelButtonTitleColor != nil) ? UIColor.cancelButton() : self.cancelButtonTitleColor
        cancelBtn.setTitleColor(cancelTitleColor, for: .normal)
        let cancelHighlightTitleColor = !(self.cancelButtonHighlightTitleColor != nil) ? UIColor.cancelButtonHighlighted() : self.cancelButtonHighlightTitleColor
        cancelBtn.setTitleColor(cancelHighlightTitleColor, for: .highlighted)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(17))
        cancelBtn.addTarget(self, action: #selector(self.cancelBtnTapped), for: .touchUpInside)
        self.view.addSubview(cancelBtn)
        let cropBtn = UIButton(type: .custom)
        cropBtn.titleLabel?.textAlignment = .right
        cropBtn.frame = CGRect(x: CGFloat(self.view.frame.width - 60), y: CGFloat(self.view.frame.height - 40), width: CGFloat(60), height: CGFloat(40))
        cropBtn.setTitle("Done", for: .normal)
        let saveButtonTitleColor = !(self.saveButtonTitleColor != nil) ? UIColor.saveButton() : self.saveButtonTitleColor
        cropBtn.setTitleColor(saveButtonTitleColor, for: .normal)
        let saveButtonHighlightTitleColor = !(self.saveButtonHighlightTitleColor != nil) ? UIColor.saveButtonHighlighted() : self.saveButtonHighlightTitleColor
        cropBtn.setTitleColor(saveButtonHighlightTitleColor, for: .normal)
        cropBtn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(17))
        cropBtn.addTarget(self, action: #selector(self.saveBtnTapped), for: .touchUpInside)
        self.view.addSubview(cropBtn)
    }

    func cancelBtnTapped() {
        self.delegate?.photoTweaksControllerDidCancel(self)
    }
    
    func saveBtnTapped() {
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
//            var library = ALAssetsLibrary()
//            library.writeImage(toSavedPhotosAlbum: image.cgImage, metadata: nil, completionBlock: {(_ assetURL: URL, _ error: Error) -> Void in
//                if error == nil {
//                    
//                }
//            })
        }
        self.delegate?.photoTweaksController(self, didFinishWithCroppedImage: image)
    }
    
    func newScaledImage(_ source: CGImage, with orientation: UIImageOrientation, to size: CGSize, with quality: CGInterpolationQuality) -> CGImage {
        var srcSize: CGSize = size
        var rotation: CGFloat = 0.0
        switch orientation {
        case .up:
            rotation = 0
        case .down:
            rotation = .pi
        case .left:
            rotation = CGFloat(M_PI_2)
            srcSize = CGSize(width: CGFloat(size.height), height: CGFloat(size.width))
        case .right:
            rotation = -(CGFloat)(M_PI_2)
            srcSize = CGSize(width: CGFloat(size.height), height: CGFloat(size.width))
        default:
            break
        }
        
        let rgbColorSpace: CGColorSpace? = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGImageByteOrderInfo.order32Big.rawValue)
        
        let context = CGContext(data: nil,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 0, //CGImageGetBitsPerComponent(source),
                                space: rgbColorSpace!,
                                bitmapInfo: bitmapInfo.rawValue //CGImageGetColorSpace(source),
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
    
    func newTransformedImage(_ transform: CGAffineTransform, sourceImage: CGImage, sourceSize: CGSize, sourceOrientation: UIImageOrientation, outputWidth: CGFloat, cropSize: CGSize, imageViewSize: CGSize) -> CGImage {
        let source: CGImage = self.newScaledImage(sourceImage, with: sourceOrientation, to: sourceSize, with: .none)
        let aspect: CGFloat = cropSize.height / cropSize.width
        let outputSize = CGSize(width: outputWidth, height: CGFloat(outputWidth * aspect))
        let context = CGContext(data: nil,
                                width: Int(outputSize.width),
                                height: Int(outputSize.height),
                                bitsPerComponent: source.bitsPerComponent,
                                bytesPerRow: 0,
                                space: source.colorSpace!,
                                bitmapInfo: source.bitmapInfo.rawValue)
        context?.setFillColor(UIColor.clear.cgColor)
        context?.fill(CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(outputSize.width), height: CGFloat(outputSize.height)))
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
}
