//
//  FCImageViewController.m
//  FCLive
//
//  Created by Sergeant on 2019/9/11.
//  Copyright © 2019 Zhijia Zhong. All rights reserved.
//

#import "FCImageViewController.h"
#import <GPUImage/GPUImage.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "FCImageFilterView.h"

@interface FCImageViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *contentView;

@end

@implementation FCImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Album" style:UIBarButtonItemStylePlain target:self action:@selector(didClickRightItem:)];
//    
//    UIImage *image = [UIImage imageNamed:@"meinv.jpg"];
//    self.imageView.image = image;
    
//    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
//    GPUImageSepiaFilter *stillImageFilter = [[GPUImageSepiaFilter alloc] init];
//    [stillImageSource addTarget:stillImageFilter];
//    [stillImageFilter useNextFrameForImageCapture];
//    [stillImageSource processImage];
//
//    UIImage *resultImage = [stillImageFilter imageFromCurrentFramebuffer];
//    self.imageView2.image = resultImage;
    
    // 只使用一个滤镜时可以用快捷方法
//    GPUImageSepiaFilter *stillImageFilter2 = [[GPUImageSepiaFilter alloc] init];
//    UIImage *resultImage = [stillImageFilter2 imageByFilteringImage:image];
//    self.imageView2.image = resultImage;
}

- (void)didClickRightItem:(UIBarButtonItem *)item {
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    vc.delegate = self;
    vc.mediaTypes = @[(NSString *) kUTTypeImage];
    vc.allowsEditing = NO;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self changeImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)configFilterViews {
    FCImageFilterView *view = [[NSBundle mainBundle] loadNibNamed:@"FCImageFilterView" owner:self options:nil].firstObject;
    [self.contentView addSubview:view];
}

- (void)changeImage:(UIImage *)image {
    GPUImage3x3ConvolutionFilter *stillImageFilter2 = [[GPUImage3x3ConvolutionFilter alloc] init];
    stillImageFilter2.convolutionKernel = (GPUMatrix3x3){
        {-1.f, -1.f, -1.f},
        {-1.f, 8.f, -1.f},
        {-1.f, -1.f, -1.f}
    };
    UIImage *resultImage = [stillImageFilter2 imageByFilteringImage:image];
}

@end
