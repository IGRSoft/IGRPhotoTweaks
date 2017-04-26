//
//  IGRPhotoTweakViewController+Angle.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/26/17.
//
//

import Foundation

extension IGRPhotoTweakViewController {
    public func changedAngle(value: CGFloat) {
        self.photoView.changedAngle(value: value)
    }
    
    public func stopChangeAngle() {
        self.photoView.stopChangeAngle()
    }
}
