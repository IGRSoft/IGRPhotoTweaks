//
//  IGRPhotoTweakView+NSLayoutConstraint.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/25/17.
//
//

import Foundation

extension IGRPhotoTweakView {
    
    internal func setupMaskLayoutConstraints() {
        
        //MARK: Top
        self.topMask.translatesAutoresizingMaskIntoConstraints = false
        
        var top = NSLayoutConstraint(item: self.topMask,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: self,
                                     attribute: .top,
                                     multiplier: 1.0,
                                     constant: 0.0)
        
        var leading = NSLayoutConstraint(item: self.topMask,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .leading,
                                         multiplier: 1.0,
                                         constant: 0.0)
        
        var trailing = NSLayoutConstraint(item: self.topMask,
                                          attribute: .trailing,
                                          relatedBy: .equal,
                                          toItem: self.cropView,
                                          attribute: .trailing,
                                          multiplier: 1.0,
                                          constant: 0.0)
        trailing.priority = .defaultHigh
        
        var bottom = NSLayoutConstraint(item: self.topMask,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: self.cropView,
                                        attribute: .top,
                                        multiplier: 1.0,
                                        constant: 0.0)
        bottom.priority = .defaultHigh
        
        self.addConstraints([top, leading, trailing, bottom])
        
        //MARK: Left
        self.leftMask.translatesAutoresizingMaskIntoConstraints = false
        
        top = NSLayoutConstraint(item: self.leftMask,
                                 attribute: .top,
                                 relatedBy: .equal,
                                 toItem: self.cropView,
                                 attribute: .top,
                                 multiplier: 1.0,
                                 constant: 0.0)
        top.priority = .defaultHigh
        
        leading = NSLayoutConstraint(item: self.leftMask,
                                     attribute: .leading,
                                     relatedBy: .equal,
                                     toItem: self,
                                     attribute: .leading,
                                     multiplier: 1.0,
                                     constant: 0.0)
        
        trailing = NSLayoutConstraint(item: self.leftMask,
                                      attribute: .trailing,
                                      relatedBy: .equal,
                                      toItem: self.cropView,
                                      attribute: .leading,
                                      multiplier: 1.0,
                                      constant: 0.0)
        trailing.priority = .defaultHigh
        
        bottom = NSLayoutConstraint(item: self.leftMask,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: self,
                                    attribute: .bottom,
                                    multiplier: 1.0,
                                    constant: 0.0)
        
        self.addConstraints([top, leading, trailing, bottom])
        
        //MARK: Right
        self.rightMask.translatesAutoresizingMaskIntoConstraints = false
        
        top = NSLayoutConstraint(item: self.rightMask,
                                 attribute: .top,
                                 relatedBy: .equal,
                                 toItem: self,
                                 attribute: .top,
                                 multiplier: 1.0,
                                 constant: 0.0)
        
        leading = NSLayoutConstraint(item: self.rightMask,
                                     attribute: .leading,
                                     relatedBy: .equal,
                                     toItem: self.cropView,
                                     attribute: .trailing,
                                     multiplier: 1.0,
                                     constant: 0.0)
        leading.priority = .defaultHigh
        
        trailing = NSLayoutConstraint(item: self.rightMask,
                                      attribute: .trailing,
                                      relatedBy: .equal,
                                      toItem: self,
                                      attribute: .trailing,
                                      multiplier: 1.0,
                                      constant: 0.0)
        
        bottom = NSLayoutConstraint(item: self.rightMask,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: self.cropView,
                                    attribute: .bottom,
                                    multiplier: 1.0,
                                    constant: 0.0)
        bottom.priority = .defaultHigh
        
        self.addConstraints([top, leading, trailing, bottom])
        
        //MARK: Bottom
        self.bottomMask.translatesAutoresizingMaskIntoConstraints = false
        
        top = NSLayoutConstraint(item: self.bottomMask,
                                 attribute: .top,
                                 relatedBy: .equal,
                                 toItem: self.cropView,
                                 attribute: .bottom,
                                 multiplier: 1.0,
                                 constant: 0.0)
        top.priority = .defaultHigh
        
        leading = NSLayoutConstraint(item: self.bottomMask,
                                     attribute: .leading,
                                     relatedBy: .equal,
                                     toItem: self.cropView,
                                     attribute: .leading,
                                     multiplier: 1.0,
                                     constant: 0.0)
        leading.priority = .defaultHigh
        
        trailing = NSLayoutConstraint(item: self.bottomMask,
                                      attribute: .trailing,
                                      relatedBy: .equal,
                                      toItem: self,
                                      attribute: .trailing,
                                      multiplier: 1.0,
                                      constant: 0.0)
        
        bottom = NSLayoutConstraint(item: self.bottomMask,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: self,
                                    attribute: .bottom,
                                    multiplier: 1.0,
                                    constant: 0.0)
        
        self.addConstraints([top, leading, trailing, bottom])
    }
}
