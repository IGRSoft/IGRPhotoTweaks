//
//  IGRPhotoScrollView.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

class IGRPhotoScrollView: UIScrollView {
    var photoContentView: IGRPhotoContentView!
    
    
    func setContentOffsetY(_ offsetY: CGFloat) {
        var contentOffset: CGPoint = self.contentOffset
        contentOffset.y = offsetY
        self.contentOffset = contentOffset
    }
    
    func setContentOffsetX(_ offsetX: CGFloat) {
        var contentOffset: CGPoint = self.contentOffset
        contentOffset.x = offsetX
        self.contentOffset = contentOffset
    }
    
    func zoomScaleToBound() -> CGFloat {
        let scaleW: CGFloat = self.bounds.size.width / self.photoContentView.bounds.size.width
        let scaleH: CGFloat = self.bounds.size.height / self.photoContentView.bounds.size.height
        
        return max(scaleW, scaleH)
    }
}
