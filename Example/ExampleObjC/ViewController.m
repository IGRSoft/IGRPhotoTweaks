//
//  ViewController.m
//  ExampleObjC
//
//  Created by Vitalii Parovishnyk on 2/11/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

@import IGRPhotoTweaks;

#import "ViewController.h"
#import "ExampleCropViewController.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, IGRPhotoTweakViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                  target:self
                                                  action:@selector(openEdit)];
    
    UIBarButtonItem *libraryItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                              target:self
                                                                              action:@selector(openLibrary)];
    
    self.navigationItem.leftBarButtonItem = libraryItem;
    self.navigationItem.rightBarButtonItem = editItem;
    
    if (self.image == nil) {
        [self openLibrary];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCrop"]) {
        ExampleCropViewController *exampleCropViewController = segue.destinationViewController;
        exampleCropViewController.image = sender;
        exampleCropViewController.delegate = self;
    }
}

- (void)openLibrary {
    UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
    pickerView.delegate = self;
    pickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:pickerView animated:YES completion:nil];
}

- (void)openEdit {
    [self edit:self.image];
}

- (void)edit:(UIImage *)image {
    [self performSegueWithIdentifier:@"showCrop" sender:image];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self edit:image];
    }];
}

#pragma mark - IGRPhotoTweakViewControllerDelegate

- (void)photoTweaksController:(IGRPhotoTweakViewController * _Nonnull)controller didFinishWithCroppedImage:(UIImage * _Nonnull)croppedImage {
    self.imageView.image = croppedImage;
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoTweaksControllerDidCancel:(IGRPhotoTweakViewController * _Nonnull)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
