<h1 align="center">IGRPhotoTweaks</h1>
<p align="center" >
<img src="https://raw.github.com/IGRSoft/IGRPhotoTweaks/Info/IGRPhotoTweaks.gif" alt="IGRPhotoTweaks" title="IGRPhotoTweaks">
</p>

IGRPhotoTweaks is a swift 3.0 library allow to expand an interface to crop photos, based on [PhotoTweaks](https://github.com/itouch2/PhotoTweaks). It can let user drag, rotate, scale the image, and crop it. You will find it mimics the interaction of Photos.app on iOS 9. :]

[![Build Status](https://travis-ci.org/IGRSoft/IGRPhotoTweaks.svg)](https://travis-ci.org/IGRSoft/IGRPhotoTweaks)
[![Pod Version](http://img.shields.io/cocoapods/v/IGRPhotoTweaks.svg?style=flat)](http://cocoapods.org/?q=IGRPhotoTweaks)
[![Platform](http://img.shields.io/cocoapods/p/IGRPhotoTweaks.svg?style=flat)](http://cocoapods.org/?q=IGRPhotoTweaks)
[![License](http://img.shields.io/cocoapods/l/IGRPhotoTweaks.svg?style=flat)](https://github.com/IGRSoft/IGRPhotoTweaks/blob/master/LICENSE)

## Usage

IGRPhotoTweaksViewController is a base interface for YourPhotoTweaksViewController.
IGRPhotoTweaksViewController offers all the operations to crop the photo, which includes translation, rotate and scale.

To use it,

```swift
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showCrop" {

        let yourCropViewController = segue.destination as! YourPhotoTweaksViewController
        yourCropViewController.image = sender as! UIImage
        yourCropViewController.delegate = self;
    }
}
```

```self.cropAction()``` is the func calls the edit done action.

```self.dismissAction()``` is the func calls the cancel edit action.

```self.changedAngel(value: radians)``` is the func to set rotation angle.

```self.setCropAspectRect(aspect: "9:16")``` is the func to set aspect ratio for crop view.

```self.resetAspectRect()``` is the func resets all previous aspect ratio.

```self.resetView()``` is the func resets all previous actions.

Get the cropped image
```swift
extension ViewController: IGRPhotoTweakViewControllerDelegate {
    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage) {
        self.imageView?.image = croppedImage
        _ = controller.navigationController?.popViewController(animated: true)
    }

    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController) {
        _ = controller.navigationController?.popViewController(animated: true)
    }
}
```

Customize View
```swift
override func viewDidLoad() {
    super.viewDidLoad()

    IGRCropLine.appearance().backgroundColor = UIColor.green
    IGRCropGridLine.appearance().backgroundColor = UIColor.yellow
    IGRCropCornerView.appearance().backgroundColor = UIColor.purple
    IGRCropCornerLine.appearance().backgroundColor = UIColor.orange
    IGRCropMaskView.appearance().backgroundColor = UIColor.blue
    IGRPhotoContentView.appearance().backgroundColor = UIColor.gray
    IGRPhotoTweakView.appearance().backgroundColor = UIColor.brown

    self.photoView.isHighlightMask = true
    self.photoView.highlightMaskAlphaValue = 0.2
    self.maxRotationAngle = CGFloat(M_PI)
    self.isAutoSaveToLibray = true
}

override func borderColor() -> UIColor {
    return UIColor.red
}

override func borderWidth() -> CGFloat {
    return 2.0
}

override func cornerBorderWidth() -> CGFloat {
    return 4.0
}

override func cornerBorderLength() -> CGFloat {
    return 30.0
}

```

## Example
IGRPhotoTweaks.xcodeproj -> IGRPhotoTweaks target
/Example

## Installation
IGRPhotoTweaks is available on [CocoaPods](http://cocoapods.org). Add the follwing to your Podfile:
```ruby
pod 'IGRPhotoTweaks', '~> 1.0.0'
```
Alternatively, you can manually drag the ```IGRPhotoTweaks``` folder into your Xcode project.

## Protip
If using with an existing UIImagePickerController, be sure to set ```allowsEditing = NO``` otherwise you may force the user to crop with the native editing tool before showing IGRPhotoTweaksViewController.
