//
//  IGRCropView.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

protocol IGRCropViewDelegate: NSObjectProtocol {
    /*
     Calls ones, when user start interaction with view
     */
    func cropViewDidStartCrop(_ cropView: IGRCropView)
    
    /*
     Calls always, when user move touch around view
     */
    func cropViewDidMove(_ cropView: IGRCropView)
    
    /*
     Calls ones, when user stop interaction with view
     */
    func cropViewDidStopCrop(_ cropView: IGRCropView)
}

class IGRCropView: UIView {
    
    //MARK: - Public VARs
    
    /*
     The optional View Delegate.
     */
    
    weak var delegate: IGRCropViewDelegate?
    
    //MARK: - Private VARs
    
    fileprivate var upperLeft:  IGRCropCornerView!
    fileprivate var upperRight: IGRCropCornerView!
    fileprivate var lowerRight: IGRCropCornerView!
    fileprivate var lowerLeft:  IGRCropCornerView!
    
    fileprivate var horizontalCropLines     = [IGRCropLine]()
    fileprivate var verticalCropLines       = [IGRCropLine]()
    
    fileprivate var horizontalGridLines     = [IGRCropGridLine]()
    fileprivate var verticalGridLines       = [IGRCropGridLine]()
    
    fileprivate var cornerBorderLength      = kCropViewCornerLength
    fileprivate var cornerBorderWidth       = kCropViewCornerWidth
    
    private(set) var isCropLinesDismissed: Bool  = false
    private(set) var isGridLinesDismissed: Bool  = false
    
    // MARK: - Life Cicle
    
    init(frame: CGRect, cornerBorderWidth: CGFloat, cornerBorderLength: CGFloat) {
        super.init(frame: frame)
        
        self.cornerBorderLength = cornerBorderLength
        self.cornerBorderWidth = cornerBorderWidth
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    fileprivate func setup() {
        for _ in 0 ..< kCropLines {
            let line = IGRCropLine()
            self.horizontalCropLines.append(line)
            self.addSubview(line)
        }
        for _ in 0 ..< kCropLines {
            let line = IGRCropLine()
            self.verticalCropLines.append(line)
            self.addSubview(line)
        }
        for _ in 0 ..< kGridLines {
            let line = IGRCropGridLine()
            self.horizontalGridLines.append(line)
            self.addSubview(line)
        }
        for _ in 0 ..< kGridLines {
            let line = IGRCropGridLine()
            self.verticalGridLines.append(line)
            self.addSubview(line)
        }
        
        self.isCropLinesDismissed = true
        self.isGridLinesDismissed = true
        
        self.upperLeft = IGRCropCornerView(cornerType: .upperLeft,
                                           lineWidth: cornerBorderWidth,
                                           lineLenght:cornerBorderLength)
        self.upperLeft.center = CGPoint(x: (cornerBorderLength / 2.0),
                                        y: (cornerBorderLength / 2.0))
        self.upperLeft.autoresizingMask = []
        self.addSubview(self.upperLeft)
        
        self.upperRight = IGRCropCornerView(cornerType: .upperRight,
                                            lineWidth: cornerBorderWidth,
                                            lineLenght:cornerBorderLength)
        self.upperRight.center = CGPoint(x: (self.frame.size.width - cornerBorderLength / 2.0),
                                         y: (cornerBorderLength / 2.0))
        self.upperRight.autoresizingMask = .flexibleLeftMargin
        self.addSubview(self.upperRight)
        
        self.lowerRight = IGRCropCornerView(cornerType: .lowerRight,
                                            lineWidth: cornerBorderWidth,
                                            lineLenght:cornerBorderLength)
        self.lowerRight.center = CGPoint(x: (self.frame.size.width - cornerBorderLength / 2.0),
                                         y: (self.frame.size.height - cornerBorderLength / 2.0))
        self.lowerRight.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        self.addSubview(self.lowerRight)
        
        self.lowerLeft = IGRCropCornerView(cornerType: .lowerLeft,
                                           lineWidth: cornerBorderWidth,
                                           lineLenght:cornerBorderLength)
        self.lowerLeft.center = CGPoint(x: (cornerBorderLength / 2.0),
                                        y: (self.frame.size.height - cornerBorderLength / 2.0))
        self.lowerLeft.autoresizingMask = .flexibleTopMargin
        self.addSubview(self.lowerLeft)
    }
    
    //MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            self.updateCropLines(false)
        }
        
        self.delegate?.cropViewDidStartCrop(self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            let location: CGPoint = (touches.first?.location(in: self))!
            var frame: CGRect = self.frame
            
            let p0 = CGPoint(x: 0.0, y: 0.0)
            let p1 = CGPoint(x: self.frame.size.width, y: 0.0)
            let p2 = CGPoint(x: 0.0, y: self.frame.size.height)
            let p3 = CGPoint(x: self.frame.size.width, y: self.frame.size.height)
            
            let canChangeWidth: Bool = frame.size.width > kMinimumCropArea
            let canChangeHeight: Bool = frame.size.height > kMinimumCropArea
            
            if IGRCropView.distanceBetweenPoints(point0: location, point1: p0) < kCropViewHotArea {
                if canChangeWidth {
                    frame.origin.x += location.x
                    frame.size.width -= location.x
                }
                
                if canChangeHeight {
                    frame.origin.y += location.y
                    frame.size.height -= location.y
                }
            }
            else if IGRCropView.distanceBetweenPoints(point0: location, point1: p1) < kCropViewHotArea {
                if canChangeWidth {
                    frame.size.width = location.x
                }
                
                if canChangeHeight {
                    frame.origin.y += location.y
                    frame.size.height -= location.y
                }
            }
            else if IGRCropView.distanceBetweenPoints(point0: location, point1: p2) < kCropViewHotArea {
                if canChangeWidth {
                    frame.origin.x += location.x
                    frame.size.width -= location.x
                }
                
                if canChangeHeight {
                    frame.size.height = location.y
                }
            }
            else if IGRCropView.distanceBetweenPoints(point0: location, point1: p3) < kCropViewHotArea {
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.cropViewDidStopCrop(self)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.cropViewDidStopCrop(self)
    }
    
    //MARK: - Crop Lines
    
    func updateCropLines(_ animate: Bool) {
        // show crop lines
        if self.isCropLinesDismissed {
            self.showCropLines()
        }
        
        let animationBlock: ((_: Void) -> Void)? = {(_: Void) -> Void in
            self.update(self.horizontalCropLines, horizontal: true)
            self.update(self.verticalCropLines, horizontal: false)
        }
        
        if animate {
            UIView.animate(withDuration: 0.25, animations: animationBlock!)
        }
        else {
            animationBlock!()
        }
    }
    
    func dismissCropLines() {
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.dismiss(self.horizontalCropLines)
            self.dismiss(self.verticalCropLines)
        }, completion: {(_ finished: Bool) -> Void in
            self.isCropLinesDismissed = true
        })
    }
    
    fileprivate func showCropLines() {
        self.isCropLinesDismissed = false
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.show(self.horizontalCropLines)
            self.show(self.verticalCropLines)
        })
    }
    
    //MARK: - Crid Lines
    
    func updateGridLines(_ animate: Bool) {
        // show grid lines
        if self.isGridLinesDismissed {
            self.showGridLines()
        }
        
        let animationBlock: ((_: Void) -> Void)? = {(_: Void) -> Void in
            self.update(self.horizontalGridLines, horizontal: true)
            self.update(self.verticalGridLines, horizontal: false)
        }
        
        if animate {
            UIView.animate(withDuration: 0.25, animations: animationBlock!)
        }
        else {
            animationBlock!()
        }
    }
    
    func dismissGridLines() {
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.dismiss(self.horizontalGridLines)
            self.dismiss(self.verticalGridLines)
        }, completion: {(_ finished: Bool) -> Void in
            self.isGridLinesDismissed = true
        })
    }
    
    fileprivate func showGridLines() {
        self.isGridLinesDismissed = false
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.show(self.horizontalGridLines)
            self.show(self.verticalGridLines)
        })
    }
    
    //MARK: - Aspect Ratio
    
    open func setCropAspectRect(aspect: String, maxSize: CGSize) {
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
        
        let x = (self.frame.size.width - size.width) / 2.0
        let y = (self.frame.size.height - size.height) / 2.0
        
        self.frame = CGRect(x:x, y:y, width: size.width, height: size.height)
    }
    
    //MARK: - Private Lines funcs
    
    fileprivate func update(_ lines: [UIView], horizontal: Bool) {
        let count = lines.count
        for (idx, line) in lines.enumerated() {
            if horizontal {
                line.frame = CGRect(x: 0.0,
                                    y: (self.frame.size.height / CGFloat(count + 1)) * CGFloat(idx + 1),
                                    width: self.frame.size.width,
                                    height: (1.0 / UIScreen.main.scale))
            }
            else {
                line.frame = CGRect(x: (self.frame.size.width / CGFloat(count + 1)) * CGFloat(idx + 1),
                                    y: 0.0,
                                    width: (1.0 / UIScreen.main.scale),
                                    height: self.frame.size.height)
            }
        }
    }
    
    fileprivate func dismiss(_ lines: [UIView]) {
        for (_, line) in lines.enumerated() {
            line.alpha = 0.0
        }
    }
    
    fileprivate func show(_ lines: [UIView]) {
        for (_, line) in lines.enumerated() {
            line.alpha = 1.0
        }
    }
    
    fileprivate static func distanceBetweenPoints(point0: CGPoint, point1: CGPoint) -> CGFloat {
        return sqrt(pow(point1.x - point0.x, 2) + pow(point1.y - point0.y, 2))
    }
}
