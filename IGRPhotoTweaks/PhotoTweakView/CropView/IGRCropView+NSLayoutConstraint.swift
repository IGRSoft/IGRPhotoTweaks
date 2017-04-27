//
//  IGRCropView+NSLayoutConstraint.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/26/17.
//
//

import Foundation
import UIKit

extension IGRCropView {
    internal func setupHorisontalLayoutConstraint(to line: UIView, multiplier: CGFloat) {
        let leading = NSLayoutConstraint(item: line,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .leading,
                                         multiplier: 1.0,
                                         constant: 0.0)
        
        let trailing = NSLayoutConstraint(item: self,
                                          attribute: .trailing,
                                          relatedBy: .equal,
                                          toItem: line,
                                          attribute: .trailing,
                                          multiplier: 1.0,
                                          constant: 0.0)
        
        let height = NSLayoutConstraint(item: line,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0,
                                        constant: 1.0)
        
        let centerY = NSLayoutConstraint(item: line,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: multiplier,
                                         constant: 0.0)
        
        self.addConstraints([leading, trailing, height, centerY])
    }
    
    internal func setupVerticalLayoutConstraint(to line: UIView, multiplier: CGFloat) {
        let top = NSLayoutConstraint(item: line,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: self,
                                     attribute: .top,
                                     multiplier: 1.0,
                                     constant: 0.0)
        
        let bottom = NSLayoutConstraint(item: self,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: line,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: 0.0)
        
        let width = NSLayoutConstraint(item: line,
                                       attribute: .width,
                                       relatedBy: .equal,
                                       toItem: nil,
                                       attribute: .notAnAttribute,
                                       multiplier: 1.0,
                                       constant: 1.0)
        
        let centerX = NSLayoutConstraint(item: line,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: multiplier,
                                         constant: 0.0)
        
        self.addConstraints([top, bottom, width, centerX])
    }
}
