//
//  IGRCropCornerLine.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/7/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

class IGRCropCornerLine: UIView {

    override class func initialize () {
        self.appearance().backgroundColor = UIColor.cropLine()
    }

}
