//
//  IGRCropView.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

@objc public protocol IGRCropViewDelegate: NSObjectProtocol {
    /*
     Calls ones, when user start interaction with view
     */
    @objc func cropViewDidStartCrop(_ cropView: IGRCropView)
    
    /*
     Calls always, when user move touch around view
     */
    @objc func cropViewDidMove(_ cropView: IGRCropView)
    
    /*
     Calls ones, when user stop interaction with view
     */
    @objc func cropViewDidStopCrop(_ cropView: IGRCropView)
}

@objc(IGRCropView) public class IGRCropView: UIView {
    
    //MARK: - Public VARs
    
    /*
     The optional View Delegate.
     */
    
    weak var delegate: IGRCropViewDelegate?
    
    //MARK: - Private VARs
    
    fileprivate var horizontalCropLines     = [IGRCropLine]()
    fileprivate var verticalCropLines       = [IGRCropLine]()
    
    fileprivate var horizontalGridLines     = [IGRCropGridLine]()
    fileprivate var verticalGridLines       = [IGRCropGridLine]()
    
    fileprivate var cornerBorderLength      = kCropViewCornerLength
    fileprivate var cornerBorderWidth       = kCropViewCornerWidth
    
    private(set) var isCropLinesDismissed: Bool  = true
    private(set) var isGridLinesDismissed: Bool  = true
    
    // MARK: - Life Cicle
    
    init(frame: CGRect, cornerBorderWidth: CGFloat, cornerBorderLength: CGFloat) {
        super.init(frame: frame)
        
        self.cornerBorderLength = cornerBorderLength
        self.cornerBorderWidth = cornerBorderWidth
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    fileprivate func setup() {
        
        var lines = self.setupLines(count: kCropLines, className: IGRCropLine.self)
        self.update(lines, horizontal: true)
        horizontalCropLines = lines as! [IGRCropLine]
        
        lines = self.setupLines(count: kCropLines, className: IGRCropLine.self)
        self.update(lines, horizontal: false)
        verticalCropLines = lines as! [IGRCropLine]
        
        lines = self.setupLines(count: kGridLines, className: IGRCropGridLine.self)
        self.update(lines, horizontal: true)
        horizontalGridLines = lines as! [IGRCropGridLine]
        
        lines = self.setupLines(count: kGridLines, className: IGRCropGridLine.self)
        self.update(lines, horizontal: false)
        verticalGridLines = lines as! [IGRCropGridLine]
        
        let upperLeft = IGRCropCornerView(cornerType: .upperLeft,
                                          lineWidth: cornerBorderWidth,
                                          lineLenght:cornerBorderLength)
        upperLeft.center = CGPoint(x: cornerBorderLength.half,
                                   y: cornerBorderLength.half)
        upperLeft.autoresizingMask  = []
        self.addSubview(upperLeft)
        
        let upperRight = IGRCropCornerView(cornerType: .upperRight,
                                           lineWidth: cornerBorderWidth,
                                           lineLenght:cornerBorderLength)
        upperRight.center = CGPoint(x: (self.frame.size.width - cornerBorderLength.half),
                                    y: cornerBorderLength.half)
        upperRight.autoresizingMask  = [.flexibleLeftMargin]
        self.addSubview(upperRight)
        
        let lowerRight = IGRCropCornerView(cornerType: .lowerRight,
                                           lineWidth: cornerBorderWidth,
                                           lineLenght:cornerBorderLength)
        lowerRight.center = CGPoint(x: (self.frame.size.width - cornerBorderLength.half),
                                    y: (self.frame.size.height - cornerBorderLength.half))
        lowerRight.autoresizingMask  = [.flexibleTopMargin, .flexibleLeftMargin]
        self.addSubview(lowerRight)
        
        let lowerLeft = IGRCropCornerView(cornerType: .lowerLeft,
                                          lineWidth: cornerBorderWidth,
                                          lineLenght:cornerBorderLength)
        lowerLeft.center = CGPoint(x: cornerBorderLength.half,
                                   y: (self.frame.size.height - cornerBorderLength.half))
        lowerLeft.autoresizingMask  = [.flexibleTopMargin]
        self.addSubview(lowerLeft)
    }
    
    fileprivate func setupLines(count: Int, className: UIView.Type) -> [UIView] {
        var lines = [UIView]()
        for _ in 0 ..< count {
            let line = className.init()
            line.alpha = CGFloat.zero
            lines.append(line)
            self.addSubview(line)
        }
        
        return lines
    }
    //MARK: - Touches
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            self.updateCropLines(false)
        }
        
        self.delegate?.cropViewDidStartCrop(self)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            let location: CGPoint = (touches.first?.location(in: self))!
            var frame: CGRect = self.frame
            
            let p0 = CGPoint(x: CGFloat.zero, y: CGFloat.zero)
            let p1 = CGPoint(x: self.frame.size.width, y: CGFloat.zero)
            let p2 = CGPoint(x: CGFloat.zero, y: self.frame.size.height)
            let p3 = CGPoint(x: self.frame.size.width, y: self.frame.size.height)
            
            let canChangeWidth: Bool = frame.size.width > kMinimumCropArea
            let canChangeHeight: Bool = frame.size.height > kMinimumCropArea
            
            if location.distanceTo(point: p0) < kCropViewHotArea {
                if canChangeWidth {
                    frame.origin.x += location.x
                    frame.size.width -= location.x
                }
                
                if canChangeHeight {
                    frame.origin.y += location.y
                    frame.size.height -= location.y
                }
            }
            else if location.distanceTo(point: p1) < kCropViewHotArea {
                if canChangeWidth {
                    frame.size.width = location.x
                }
                
                if canChangeHeight {
                    frame.origin.y += location.y
                    frame.size.height -= location.y
                }
            }
            else if location.distanceTo(point: p2) < kCropViewHotArea {
                if canChangeWidth {
                    frame.origin.x += location.x
                    frame.size.width -= location.x
                }
                
                if canChangeHeight {
                    frame.size.height = location.y
                }
            }
            else if location.distanceTo(point: p3) < kCropViewHotArea {
                if canChangeWidth {
                    frame.size.width = location.x
                }
                
                if canChangeHeight {
                    frame.size.height = location.y
                }
            }
            else if fabs(location.x - p0.x) < kCropViewHotArea {
                if canChangeWidth {
                    frame.origin.x += location.x
                    frame.size.width -= location.x
                }
            }
            else if fabs(location.x - p1.x) < kCropViewHotArea {
                if canChangeWidth {
                    frame.size.width = location.x
                }
            }
            else if fabs(location.y - p0.y) < kCropViewHotArea {
                if canChangeHeight {
                    frame.origin.y += location.y
                    frame.size.height -= location.y
                }
            }
            else if fabs(location.y - p2.y) < kCropViewHotArea {
                if canChangeHeight {
                    frame.size.height = location.y
                }
            }
            
            self.frame = frame
            
            // update crop lines
            self.updateCropLines(false)
            
            self.delegate?.cropViewDidMove(self)
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.cropViewDidStopCrop(self)
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.cropViewDidStopCrop(self)
    }
    
    //MARK: - Crop Lines
    
    func updateCropLines(_ animate: Bool) {
        // show crop lines
        self.showCropLines()
        
        let animationBlock: ((_: Void) -> Void)? = {(_: Void) -> Void in
            self.update(self.horizontalCropLines, horizontal: true)
            self.update(self.verticalCropLines, horizontal: false)
        }
        
        if animate {
            UIView.animate(withDuration: kAnimationDuration, animations: animationBlock!)
        }
        else {
            animationBlock!()
        }
    }
    
    func dismissCropLines() {
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
    
    //MARK: - Crid Lines
    
    func updateGridLines(_ animate: Bool) {
        // show grid lines
        self.showGridLines()
        
        let animationBlock: ((_: Void) -> Void)? = {(_: Void) -> Void in
            self.update(self.horizontalGridLines, horizontal: true)
            self.update(self.verticalGridLines, horizontal: false)
        }
        
        if animate {
            UIView.animate(withDuration: kAnimationDuration, animations: animationBlock!)
        }
        else {
            animationBlock!()
        }
    }
    
    func dismissGridLines() {
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
    
    //MARK: - Aspect Ratio
    
    public func setCropAspectRect(aspect: String, maxSize: CGSize) {
        let elements = aspect.components(separatedBy: ":")
        let width: CGFloat = CGFloat(Float(elements.first!)!)
        let height: CGFloat = CGFloat(Float(elements.last!)!)
        
        var size = maxSize
        let mW = size.width / width
        let mH = size.height / height
        
        if (mH < mW) {
            size.width = size.height / height * width
        }
        else if(mW < mH) {
            size.height = size.width / width * height
        }
        
        let x = (self.frame.size.width - size.width).half
        let y = (self.frame.size.height - size.height).half
        
        self.frame = CGRect(x:x, y:y, width: size.width, height: size.height)
    }
    
    //MARK: - Private Lines funcs
    
    fileprivate func update(_ lines: [UIView], horizontal: Bool) {
        let count = lines.count
        let scale = (1.0 / UIScreen.main.scale)
        for (idx, line) in lines.enumerated() {
            if horizontal {
                line.frame = CGRect(x: CGFloat.zero,
                                    y: (self.frame.size.height / CGFloat(count + 1)) * CGFloat(idx + 1),
                                    width: self.frame.size.width,
                                    height: scale)
            }
            else {
                line.frame = CGRect(x: (self.frame.size.width / CGFloat(count + 1)) * CGFloat(idx + 1),
                                    y: CGFloat.zero,
                                    width: scale,
                                    height: self.frame.size.height)
            }
        }
    }
    
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
