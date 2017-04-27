//
//  CropTests.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 4/27/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import XCTest

@testable import IGRPhotoTweaks

class CropTests: XCTestCase {
    
    var testImage = { () -> UIImage? in 
        let bundle = Bundle(for: IGRPhotoTweaksTests.self)
        return UIImage(named: "test-image", in: bundle, compatibleWith: nil)
    }
    
    let originalImageSize = CGSize(width: 100, height: 56)
    let cropImageSize = CGSize(width: 50, height: 25)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testImageCrop() {
        let image = testImage()
        
        XCTAssertNotNil(image)
        
        if let fixedImage = image?.cgImageWithFixedOrientation() {
            let imageRef = fixedImage.transformedImage(CGAffineTransform.identity,
                                                       sourceSize: originalImageSize,
                                                       outputWidth: originalImageSize.width,
                                                       cropSize: cropImageSize,
                                                       imageViewSize: originalImageSize)
            
            let resultImage = UIImage(cgImage: imageRef, scale: 2.0, orientation: .up)
            
            XCTAssertNotNil(resultImage, "Can't crop image")
            XCTAssert(resultImage.size.equalTo(cropImageSize), "Wrong crop size")
            
        } else {
            XCTAssert(false, "Can't fix Image")
        }
    }
}
