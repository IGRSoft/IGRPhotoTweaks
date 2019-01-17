//
//  IGRPhotoTweakViewController+Rotation.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 1/17/19.
//
//

import Foundation

extension IGRPhotoTweakViewController {
    
    public func rotateImageLeft() {
        self.photoView?.rotateImageLeft()
        self.image = self.photoView?.image
    }
    
    public func rotateImageRight() {
        self.photoView?.rotateImageRight()
        self.image = self.photoView?.image
    }
}
