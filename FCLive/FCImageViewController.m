//
//  FCImageViewController.m
//  FCLive
//
//  Created by Sergeant on 2019/9/11.
//  Copyright © 2019 Zhijia Zhong. All rights reserved.
//

#import "FCImageViewController.h"
#import <GPUImage/GPUImage.h>

@interface FCImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@end

@implementation FCImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *image = [UIImage imageNamed:@"meinv.jpg"];
    self.imageView.image = image;
    
//    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
//    GPUImageSepiaFilter *stillImageFilter = [[GPUImageSepiaFilter alloc] init];
//    [stillImageSource addTarget:stillImageFilter];
//    [stillImageFilter useNextFrameForImageCapture];
//    [stillImageSource processImage];
//
//    UIImage *resultImage = [stillImageFilter imageFromCurrentFramebuffer];
//    self.imageView2.image = resultImage;
    
    // 只使用一个滤镜时可以用快捷方法
    GPUImageSepiaFilter *stillImageFilter2 = [[GPUImageSepiaFilter alloc] init];
    UIImage *resultImage = [stillImageFilter2 imageByFilteringImage:image];
    self.imageView2.image = resultImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
