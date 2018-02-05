//
//  IGRPhotoTweakViewController+PHPhotoLibrary.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/26/17.
//
//

import Foundation
import Photos

extension IGRPhotoTweakViewController {

    internal func saveToLibrary(image: UIImage) {
        let writePhotoToLibraryBlock: (() -> Void)? = {
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
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
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
}
