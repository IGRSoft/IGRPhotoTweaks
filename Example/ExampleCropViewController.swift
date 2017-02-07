//
//  ExampleCropViewController.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/7/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

class ExampleCropViewController: IGRPhotoTweakViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FIXME: Themes Preview
        //IGRCropLine.appearance().backgroundColor = UIColor.green
        //IGRCropGridLine.appearance().backgroundColor = UIColor.yellow
        //IGRCropCornerView.appearance().backgroundColor = UIColor.purple
        //IGRCropCornerLine.appearance().backgroundColor = UIColor.orange
        //IGRCropMaskView.appearance().backgroundColor = UIColor.blue
        //IGRPhotoContentView.appearance().backgroundColor = UIColor.gray
        //IGRPhotoTweakView.appearance().backgroundColor = UIColor.brown
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //FIXME: Themes Preview
//    override func borderColor() -> UIColor {
//        return UIColor.red
//    }
//    
//    override func borderWidth() -> CGFloat {
//        return 2.0
//    }
//    
//    override func cornerBorderWidth() -> CGFloat {
//        return 4.0
//    }
//    
//    override func cornerBorderLength() -> CGFloat {
//        return 30.0
//    }
}
