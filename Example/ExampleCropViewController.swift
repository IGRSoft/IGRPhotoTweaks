//
//  ExampleCropViewController.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/7/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import IGRPhotoTweaks

import UIKit
import KCHorizontalDial

class ExampleCropViewController: IGRPhotoTweakViewController {

    /**
     Slider to change angel.
     */
    @IBOutlet weak fileprivate var angelSlider: UISlider?
    @IBOutlet weak fileprivate var angelLabel: UILabel?
    @IBOutlet weak fileprivate var horizontalDial: KCHorizontalDial? {
        didSet {
            self.horizontalDial?.migneticOption = .none
        }
    }
    
    // MARK: - Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSlider()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //FIXME: Themes Preview
    /*override open func setupThemes() {
        
        IGRCropLine.appearance().backgroundColor = UIColor.green
        IGRCropGridLine.appearance().backgroundColor = UIColor.yellow
        IGRCropCornerView.appearance().backgroundColor = UIColor.purple
        IGRCropCornerLine.appearance().backgroundColor = UIColor.orange
        IGRCropMaskView.appearance().backgroundColor = UIColor.blue
        IGRPhotoContentView.appearance().backgroundColor = UIColor.gray
        IGRPhotoTweakView.appearance().backgroundColor = UIColor.brown
    }*/
    
    fileprivate func setupSlider() {
        self.angelSlider?.minimumValue = -Float(IGRRadianAngle.toRadians(45))
        self.angelSlider?.maximumValue = Float(IGRRadianAngle.toRadians(45))
        self.angelSlider?.value = 0.0
        
        setupAngelLabelValue(radians: CGFloat((self.angelSlider?.value)!))
    }
    
    fileprivate func setupAngelLabelValue(radians: CGFloat) {
        let intDegrees: Int = Int(IGRRadianAngle.toDegrees(radians))
        self.angelLabel?.text = "\(intDegrees)°"
    }
    
    // MARK: - Actions
    
    @IBAction func onChandeAngelSliderValue(_ sender: UISlider) {
        let radians: CGFloat = CGFloat(sender.value)
        setupAngelLabelValue(radians: radians)
        self.changedAngel(value: radians)

    }
    
    @IBAction func onEndTouchAngelControl(_ sender: UIControl) {
        self.stopChangeAngel()
    }
    
    @IBAction func onTouchResetButton(_ sender: UIButton) {
        self.angelSlider?.value = 0.0
        self.horizontalDial?.value = 0.0
        setupAngelLabelValue(radians: 0.0)
        
        self.resetView()
    }
    
    @IBAction func onTouchCancelButton(_ sender: UIButton) {
        self.dismissAction()
    }
    
    @IBAction func onTouchCropButton(_ sender: UIButton) {
        cropAction()
    }
    
    
    @IBAction func onTouchAspectButton(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        
        actionSheet.addAction(UIAlertAction(title: "Original", style: .default) { (action) in
            self.resetAspectRect()
        })
        
        actionSheet.addAction(UIAlertAction(title: "Squere", style: .default) { (action) in
            self.setCropAspectRect(aspect: "1:1")
        })
        
        actionSheet.addAction(UIAlertAction(title: "2:3", style: .default) { (action) in
            self.setCropAspectRect(aspect: "2:3")
        })
        
        actionSheet.addAction(UIAlertAction(title: "3:5", style: .default) { (action) in
            self.setCropAspectRect(aspect: "3:5")
        })
        
        actionSheet.addAction(UIAlertAction(title: "3:4", style: .default) { (action) in
            self.setCropAspectRect(aspect: "3:4")
        })
        
        actionSheet.addAction(UIAlertAction(title: "5:7", style: .default) { (action) in
            self.setCropAspectRect(aspect: "5:7")
        })
        
        actionSheet.addAction(UIAlertAction(title: "9:16", style: .default) { (action) in
            self.setCropAspectRect(aspect: "9:16")
        })
        
        actionSheet.addAction(UIAlertAction(title: "9:16", style: .cancel))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    //FIXME: Themes Preview
//    override open func customBorderColor() -> UIColor {
//        return UIColor.red
//    }
//    
//    override open func customBorderWidth() -> CGFloat {
//        return 2.0
//    }
//    
//    override open func customCornerBorderWidth() -> CGFloat {
//        return 4.0
//    }
//    
//    override open func customCornerBorderLength() -> CGFloat {
//        return 30.0
//    }
//    
//    override open func customIsHighlightMask() -> Bool {
//        return true
//    }
//    
//    override open func customHighlightMaskAlphaValue() -> CGFloat {
//        return 0.3
//    }
}

extension ExampleCropViewController: KCHorizontalDialDelegate {
    func horizontalDialDidValueChanged(_ horizontalDial: KCHorizontalDial) {
        let degrees = horizontalDial.value
        let radians = IGRRadianAngle.toRadians(CGFloat(degrees))
        
        self.setupAngelLabelValue(radians: radians)
        self.changedAngel(value: radians)
    }
    
    func horizontalDialDidEndScroll(_ horizontalDial: KCHorizontalDial) {
        self.stopChangeAngel()
    }
}
