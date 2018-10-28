//
//  ExampleCropViewController.m
//  Example
//
//  Created by Vitalii Parovishnyk on 2/11/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

@import UIKit;

#import "ExampleCropViewController.h"

@interface ExampleCropViewController ()

@property (nonatomic, weak) IBOutlet UISlider *angleSlider;
@property (nonatomic, weak) IBOutlet UILabel *angleLabel;

@end

@implementation ExampleCropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //FIXME: Themes Preview
    //IGRCropLine.appearance().backgroundColor = UIColor.green
    //IGRCropGridLine.appearance().backgroundColor = UIColor.yellow
    //IGRCropCornerView.appearance().backgroundColor = UIColor.purple
    //IGRCropCornerLine.appearance().backgroundColor = UIColor.orange
    //IGRCropMaskView.appearance().backgroundColor = UIColor.blue
    //IGRPhotoContentView.appearance().backgroundColor = UIColor.gray
    //IGRPhotoTweakView.appearance().backgroundColor = UIColor.brown
    
    //FIXME: Customization
    //self.photoView.isHighlightMask = true
    //self.photoView.highlightMaskAlphaValue = 0.2
    //self.maxRotationAngle = CGFloat(M_PI)
    //self.isAutoSaveToLibray = true
    
    [self setupSlider];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSlider {
    self.angleSlider.minimumValue = -[IGRRadianAngle toRadians:45.0];
    self.angleSlider.maximumValue = [IGRRadianAngle toRadians:45.0];
    self.angleSlider.value = CGFloat.zero;
    
    [self setupAngleLabelValue:self.angleSlider.value];
}

- (void)setupAngleLabelValue:(CGFloat)radians {
    NSUInteger intDegrees = [IGRRadianAngle toDegrees:radians];
    self.angleLabel.text = [NSString stringWithFormat:@"%@°", @(intDegrees)];
}

// MARK: - Actions

- (IBAction)onChandeAngleSliderValue:(UISlider *)sender {
    CGFloat radians = sender.value;
    [self setupAngleLabelValue:radians];
    [self changeAngleWithValue:radians];
}

- (IBAction)onEndTouchAngleControl:(UIControl *)sender {
    [self stopChangeAngle];
}

- (IBAction)onChandeAnglePickerViewValue:(UIPickerView *)sender {
    CGFloat radians = CGFloat.zero;
    [self setupAngleLabelValue:radians];
    [self changeAngleWithValue:radians];
}

- (IBAction)onTouchResetButton:(UIButton *)sender {
    self.angleSlider.value = CGFloat.zero;
    [self setupAngleLabelValue:self.angleSlider.value];
    
    [self resetView];
}

- (IBAction)onTouchCancelButton:(UIButton *)sender {
    [self dismissAction];
}

- (IBAction)onTouchCropButton:(UIButton *)sender {
    [self cropAction];
}


- (IBAction)onTouchAspectButton:(UIButton *)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Original"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      [self resetAspectRect];
                                                  }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Squere"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      [self setCropAspectRectWithAspect:@"1:1"];
                                                  }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"2:3"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      [self setCropAspectRectWithAspect:@"2:3"];
                                                  }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"3:5"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      [self setCropAspectRectWithAspect:@"3:5"];
                                                  }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"3:4"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      [self setCropAspectRectWithAspect:@"3:4"];
                                                  }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"5:7"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      [self setCropAspectRectWithAspect:@"5:7"];
                                                  }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"9:16"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      [self setCropAspectRectWithAspect:@"9:16"];
                                                  }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

@end
