//
//  IGRCropView.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

protocol IGRCropViewDelegate: NSObjectProtocol {
    func cropEnded(_ cropView: IGRCropView)
    
    func cropMoved(_ cropView: IGRCropView)
}

class IGRCropView: UIView {
    
    var upperLeft:  IGRCropCornerView!
    var upperRight: IGRCropCornerView!
    var lowerRight: IGRCropCornerView!
    var lowerLeft:  IGRCropCornerView!
    
    var horizontalCropLines     = [UIView]()
    var verticalCropLines       = [UIView]()
    
    var horizontalGridLines     = [UIView]()
    var verticalGridLines       = [UIView]()
    
    weak var delegate: IGRCropViewDelegate?
    
    var isCropLinesDismissed: Bool  = false
    var isGridLinesDismissed: Bool  = false
    
    static func distanceBetweenPoints(point0: CGPoint, point1: CGPoint) -> CGFloat {
        return sqrt(pow(point1.x - point0.x, 2) + pow(point1.y - point0.y, 2))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    fileprivate func setup() {
        self.layer.borderColor = UIColor.cropLine().cgColor
        self.layer.borderWidth = 1
        for _ in 0..<kCropLines {
            let line = UIView()
            line.backgroundColor = UIColor.cropLine()
            self.horizontalCropLines.append(line)
            self.addSubview(line)
        }
        for _ in 0..<kCropLines {
            let line = UIView()
            line.backgroundColor = UIColor.cropLine()
            self.verticalCropLines.append(line)
            self.addSubview(line)
        }
        for _ in 0..<kGridLines {
            let line = UIView()
            line.backgroundColor = UIColor.gridLine()
            self.horizontalGridLines.append(line)
            self.addSubview(line)
        }
        for _ in 0..<kGridLines {
            let line = UIView()
            line.backgroundColor = UIColor.gridLine()
            self.verticalGridLines.append(line)
            self.addSubview(line)
        }
        
        self.isCropLinesDismissed = true
        self.isGridLinesDismissed = true
        
        self.upperLeft = IGRCropCornerView(cornerType: .upperLeft)
        self.upperLeft.center = CGPoint(x: CGFloat(kCropViewCornerLength / 2), y: CGFloat(kCropViewCornerLength / 2))
        self.upperLeft.autoresizingMask = []
        self.addSubview(self.upperLeft)
        
        self.upperRight = IGRCropCornerView(cornerType: .upperRight)
        self.upperRight.center = CGPoint(x: CGFloat(self.frame.size.width - kCropViewCornerLength / 2), y: CGFloat(kCropViewCornerLength / 2))
        self.upperRight.autoresizingMask = .flexibleLeftMargin
        self.addSubview(self.upperRight)
        
        self.lowerRight = IGRCropCornerView(cornerType: .lowerRight)
        self.lowerRight.center = CGPoint(x: CGFloat(self.frame.size.width - kCropViewCornerLength / 2), y: CGFloat(self.frame.size.height - kCropViewCornerLength / 2))
        self.lowerRight.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        self.addSubview(self.lowerRight)
        
        self.lowerLeft = IGRCropCornerView(cornerType: .lowerLeft)
        self.lowerLeft.center = CGPoint(x: CGFloat(kCropViewCornerLength / 2), y: CGFloat(self.frame.size.height - kCropViewCornerLength / 2))
        self.lowerLeft.autoresizingMask = .flexibleTopMargin
        self.addSubview(self.lowerLeft)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            self.updateCropLines(false)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            let location: CGPoint = (touches.first?.location(in: self))!
            var frame: CGRect = self.frame
            let p0 = CGPoint(x: CGFloat(0), y: CGFloat(0))
            let p1 = CGPoint(x: CGFloat(self.frame.size.width), y: CGFloat(0))
            let p2 = CGPoint(x: CGFloat(0), y: CGFloat(self.frame.size.height))
            let p3 = CGPoint(x: CGFloat(self.frame.size.width), y: CGFloat(self.frame.size.height))
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
            
            self.delegate?.cropMoved(self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.cropEnded(self)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
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
    
    func update(_ lines: [UIView], horizontal: Bool) {
        let count = lines.count
        for (idx, line) in lines.enumerated() {
            if horizontal {
                line.frame = CGRect(x: 0.0,
                                    y: (self.frame.size.height / CGFloat(count + 1)) * CGFloat(idx + 1),
                                    width: self.frame.size.width,
                                    height: CGFloat(1.0 / UIScreen.main.scale))
            }
            else {
                line.frame = CGRect(x: (self.frame.size.width / CGFloat(count + 1)) * CGFloat(idx + 1),
                                    y: 0.0,
                                    width: (1.0 / UIScreen.main.scale),
                                    height: self.frame.size.height)
            }
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
    
    func dismissGridLines() {
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.dismiss(self.horizontalGridLines)
            self.dismiss(self.verticalGridLines)
        }, completion: {(_ finished: Bool) -> Void in
            self.isGridLinesDismissed = true
        })
    }
    
    func dismiss(_ lines: [UIView]) {
        for (_, line) in lines.enumerated() {
            line.alpha = 0.0
        }
    }
    
    func showCropLines() {
        self.isCropLinesDismissed = false
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.show(self.horizontalCropLines)
            self.show(self.verticalCropLines)
        })
    }
    
    func showGridLines() {
        self.isGridLinesDismissed = false
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.show(self.horizontalGridLines)
            self.show(self.verticalGridLines)
        })
    }
    
    func show(_ lines: [UIView]) {
        for (_, line) in lines.enumerated() {
            line.alpha = 1.0
        }
    }
}
