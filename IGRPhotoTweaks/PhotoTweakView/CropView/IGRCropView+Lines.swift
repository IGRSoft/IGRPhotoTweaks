//
//  IGRCropView+Lines.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/26/17.
//
//

import Foundation

extension IGRCropView {
    
    internal func seetupLines() {
        self.dismiss(self.horizontalCropLines)
        self.dismiss(self.verticalCropLines)
        self.dismiss(self.horizontalGridLines)
        self.dismiss(self.verticalGridLines)
    }
    
    fileprivate func createLine(for className: UIView.Type) -> UIView {
        let line = className.init()
        line.alpha = CGFloat.zero
        self.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        
        return line
    }
    
    internal func setupHorisontalLines(count: Int, className: UIView.Type) -> [UIView] {
        var lines = [UIView]()
        for idx in 0 ..< count {
            let line = self.createLine(for: className)
            lines.append(line)
            
            self.setupHorisontalLayoutConstraint(to: line,
                                                 multiplier: (CGFloat(idx+1) / (CGFloat(count + 1) / 2.0)))
        }
        
        return lines
    }
    
    internal func setupVerticalLines(count: Int, className: UIView.Type) -> [UIView] {
        var lines = [UIView]()
        for idx in 0 ..< count {
            let line = self.createLine(for: className)
            lines.append(line)
            
            self.setupVerticalLayoutConstraint(to: line,
                                               multiplier: (CGFloat(idx+1) / (CGFloat(count + 1) / 2.0)))
        }
        
        return lines
    }
    
    //MARK: Crop Lines
    
    public func updateCropLines(animate: Bool) {
        // show crop lines
        self.showCropLines()
        
        let animationBlock: (() -> Void)? = {
            self.layoutIfNeeded()
        }
        
        if animate {
            UIView.animate(withDuration: kAnimationDuration, animations: animationBlock!)
        }
        else {
            animationBlock!()
        }
    }
    
    public func dismissCropLines() {
        UIView.animate(withDuration: kAnimationDuration, animations: {() -> Void in
            self.dismiss(self.horizontalCropLines)
            self.dismiss(self.verticalCropLines)
        }, completion: {(_ finished: Bool) -> Void in
            self.isCropLinesDismissed = true
        })
    }
    
    fileprivate func showCropLines() {
        if self.isCropLinesDismissed {
            self.isCropLinesDismissed = false
            UIView.animate(withDuration: kAnimationDuration, animations: {() -> Void in
                self.show(self.horizontalCropLines)
                self.show(self.verticalCropLines)
            })
        }
    }
    
    //MARK: Crid Lines
    
    public func updateGridLines(animate: Bool) {
        // show grid lines
        self.showGridLines()
        
        let animationBlock: (() -> Void)? = {
            self.layoutIfNeeded()
        }
        
        if animate {
            UIView.animate(withDuration: kAnimationDuration, animations: animationBlock!)
        }
        else {
            animationBlock!()
        }
    }
    
    public func dismissGridLines() {
        UIView.animate(withDuration: kAnimationDuration, animations: {() -> Void in
            self.dismiss(self.horizontalGridLines)
            self.dismiss(self.verticalGridLines)
        }, completion: {(_ finished: Bool) -> Void in
            self.isGridLinesDismissed = true
        })
    }
    
    fileprivate func showGridLines() {
        if self.isGridLinesDismissed {
            self.isGridLinesDismissed = false
            UIView.animate(withDuration: kAnimationDuration, animations: {() -> Void in
                self.show(self.horizontalGridLines)
                self.show(self.verticalGridLines)
            })
        }
    }
    
    //MARK: - Private Lines funcs
    
    fileprivate func dismiss(_ lines: [UIView]) {
        for (_, line) in lines.enumerated() {
            line.alpha = CGFloat.zero
        }
    }
    
    fileprivate func show(_ lines: [UIView]) {
        for (_, line) in lines.enumerated() {
            line.alpha = 1.0
        }
    }
}
