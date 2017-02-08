//
//  CGFloat+Tweak.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/8/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import CoreGraphics

class IGRRadianAngle : NSObject {
    
    static func toRadians(_ degrees: CGFloat) -> CGFloat {
        return (degrees * CGFloat(M_PI) / 180.0)
    }
    
    static func toDegrees(_ radians: CGFloat) -> CGFloat {
        return (radians * 180.0 / CGFloat(M_PI))
    }
}
