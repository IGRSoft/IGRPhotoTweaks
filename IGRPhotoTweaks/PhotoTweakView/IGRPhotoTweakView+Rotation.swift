//
//  IGRPhotoTweakView+Rotation.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 17/1/19.
//  Copyright © 2019 IGR Software. All rights reserved.
//

import Foundation

extension IGRPhotoTweakView {
    
    public func rotateImageLeft() {
        if let img = self.image?.rotate(-.pi * 0.5) {
            self.image = img
            self.originalSize = maxBounds().size
            
            updateImage()
        }
    }
    
    public func rotateImageRight() {
        if let img = self.image?.rotate(.pi * 0.5) {
            self.image = img
            self.originalSize = maxBounds().size
            
            updateImage()
        }
    }
}
