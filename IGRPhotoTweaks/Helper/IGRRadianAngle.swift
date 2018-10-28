//
//  CGFloat+Tweak.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/8/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import CoreGraphics

open class IGRRadianAngle : NSObject {
    
    static public func toRadians(_ degrees: CGFloat) -> CGFloat {
        return (degrees * CGFloat.pi / 180.0)
    }
    
    static public func toDegrees(_ radians: CGFloat) -> CGFloat {
        return (radians * 180.0 / CGFloat.pi)
    }
}
