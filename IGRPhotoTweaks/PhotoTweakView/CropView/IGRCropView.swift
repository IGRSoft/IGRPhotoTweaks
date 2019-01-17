//
//  IGRCropView.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

public protocol IGRCropViewDelegate : class {
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
    
    /*
     Calls ones, when change a Crop frame
     */
    func cropViewInsideValidFrame(for point: CGPoint, from cropView: IGRCropView) -> Bool
}

public class IGRCropView: UIView {
    
    //MARK: - Public VARs
    
    /*
     The optional View Delegate.
     */
    
    weak var delegate: IGRCropViewDelegate?
    
    //MARK: - Private VARs
    
    internal lazy var horizontalCropLines: [IGRCropLine] = { [unowned self] by in
        var lines = self.setupHorisontalLines(count: self.cropLinesCount,
                                              className: IGRCropLine.self)
        return lines as! [IGRCropLine]
        }(())
    
    internal lazy var verticalCropLines: [IGRCropLine] = { [unowned self] by in
        var lines = self.setupVerticalLines(count: self.cropLinesCount,
                                            className: IGRCropLine.self)
        return lines as! [IGRCropLine]
        }(())
    
    internal lazy var horizontalGridLines: [IGRCropGridLine] = { [unowned self] by in
        var lines = self.setupHorisontalLines(count: self.gridLinesCount,
                                              className: IGRCropGridLine.self)
        return lines as! [IGRCropGridLine]
        }(())
    internal lazy var verticalGridLines: [IGRCropGridLine] = { [unowned self] by in
        var lines = self.setupVerticalLines(count: self.gridLinesCount,
                                            className: IGRCropGridLine.self)
        return lines as! [IGRCropGridLine]
        }(())
    
    internal var cornerBorderLength      = kCropViewCornerLength
    internal var cornerBorderWidth       = kCropViewCornerWidth
    
    internal var cropLinesCount         = kCropLinesCount
    internal var gridLinesCount         = kGridLinesCount
    
    internal var isCropLinesDismissed: Bool  = true
    internal var isGridLinesDismissed: Bool  = true
    
    internal var isAspectRatioLocked: Bool = false
    internal var aspectRatioWidth: CGFloat = CGFloat.zero
    internal var aspectRatioHeight: CGFloat = CGFloat.zero
    
    // MARK: - Life Cicle
    
    init(frame: CGRect,
         cornerBorderWidth: CGFloat,
         cornerBorderLength: CGFloat,
         cropLinesCount: Int,
         gridLinesCount: Int) {
        super.init(frame: frame)
        
        self.cornerBorderLength = cornerBorderLength
        self.cornerBorderWidth = cornerBorderWidth
        
        self.cropLinesCount = cropLinesCount
        self.gridLinesCount = gridLinesCount
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    fileprivate func setup() {
        
        self.setupLines()
        
        let upperLeft = IGRCropCornerView(cornerType: .upperLeft,
                                          lineWidth: cornerBorderWidth,
                                          lineLenght: cornerBorderLength)
        upperLeft.center = CGPoint(x: cornerBorderLength.half,
                                   y: cornerBorderLength.half)
        self.addSubview(upperLeft)
        
        let upperRight = IGRCropCornerView(cornerType: .upperRight,
                                           lineWidth: cornerBorderWidth,
                                           lineLenght:cornerBorderLength)
        upperRight.center = CGPoint(x: (self.frame.size.width - cornerBorderLength.half),
                                    y: cornerBorderLength.half)
        self.addSubview(upperRight)
        
        let lowerRight = IGRCropCornerView(cornerType: .lowerRight,
                                           lineWidth: cornerBorderWidth,
                                           lineLenght:cornerBorderLength)
        lowerRight.center = CGPoint(x: (self.frame.size.width - cornerBorderLength.half),
                                    y: (self.frame.size.height - cornerBorderLength.half))
        self.addSubview(lowerRight)
        
        let lowerLeft = IGRCropCornerView(cornerType: .lowerLeft,
                                          lineWidth: cornerBorderWidth,
                                          lineLenght:cornerBorderLength)
        lowerLeft.center = CGPoint(x: cornerBorderLength.half,
                                   y: (self.frame.size.height - cornerBorderLength.half))
        self.addSubview(lowerLeft)
        
        resetAspectRect()
    }
}
