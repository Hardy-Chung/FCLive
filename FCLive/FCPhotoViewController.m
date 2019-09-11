//
//  FCPhotoViewController.m
//  FCLive
//
//  Created by Zhijia Zhong on 2019/9/11.
//  Copyright © 2019 Zhijia Zhong. All rights reserved.
//

#import "FCPhotoViewController.h"
#import <GPUImage/GPUImage.h>

@interface FCPhotoViewController ()

@property (weak, nonatomic) IBOutlet GPUImageView *imageView;
@property (nonatomic, strong) GPUImageStillCamera *stillCamera;

@end

@implementation FCPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stillCamera = [[GPUImageStillCamera alloc] init];
    self.stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    GPUImageGammaFilter *filter = [[GPUImageGammaFilter alloc] init];
    filter.gamma = 0.5;
    [self.stillCamera addTarget:filter];
    [filter addTarget:self.imageView];
    
    [self.stillCamera startCameraCapture];
}

- (IBAction)didClickTakeButton:(UIButton *)sender {
    [self.stillCamera capturePhotoAsImageProcessedUpToFilter:self.stillCamera.targets.firstObject withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        UIImageWriteToSavedPhotosAlbum(processedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
}

#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
}

@end
