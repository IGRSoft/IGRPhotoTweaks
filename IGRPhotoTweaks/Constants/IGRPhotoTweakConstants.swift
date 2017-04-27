//
//  IGRPhotoTweakConstants.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

enum CropCornerType : Int {
    case upperLeft
    case upperRight
    case lowerRight
    case lowerLeft
}

let kCropLines: Int = 2
let kGridLines: Int = 8

let kCropViewHotArea: CGFloat = 40.0

let kMaximumCanvasWidthRatio: CGFloat  = 0.9
let kMaximumCanvasHeightRatio: CGFloat = 0.8
let kCanvasHeaderHeigth: CGFloat       = 100.0

let kCropViewLineWidth: CGFloat  = 2.0

let kCropViewCornerWidth: CGFloat  = 2.0
let kCropViewCornerLength: CGFloat = 22.0

let kAnimationDuration: TimeInterval = 0.25
