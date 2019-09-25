//
//  FCImageViewController.m
//  FCLive
//
//  Created by Sergeant on 2019/9/11.
//  Copyright © 2019 Zhijia Zhong. All rights reserved.
//

#import "FCImageViewController.h"
#import "FCFilterManager.h"
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.contentView.frame = UIEdgeInsetsInsetRect(self.view.bounds, self.view.safeAreaInsets);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIImage *image = [UIImage imageNamed:@"meinv.jpg"];
    [self changeImage:image];
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
    NSInteger filterCount = FCFilterManager.defaultManager.allFilters.count;
    for (NSInteger idx = 0; idx < filterCount; idx++) {
        FCImageFilterView *idxView = [[NSBundle mainBundle] loadNibNamed:@"FCImageFilterView" owner:self options:nil].firstObject;;
        CGRect frame = self.contentView.bounds;
        frame.origin.x = CGRectGetWidth(frame) * idx;
        idxView.frame = frame;
        [self.contentView addSubview:idxView];
    }
    self.contentView.contentSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds) * filterCount, CGRectGetHeight(self.contentView.bounds));
}

- (void)changeImage:(UIImage *)image {
    if (self.contentView.subviews.count == 0) {
        [self configFilterViews];
    }
    
    for (NSInteger idx = 0; idx < FCFilterManager.defaultManager.allFilters.count; idx++) {
        FCImageFilterView *idxView = self.contentView.subviews[idx];
        GPUImageFilter *filter = FCFilterManager.defaultManager.allFilters[idx];
        
        idxView.nameLabel.text = NSStringFromClass([filter class]);
        idxView.originalImageView.image = image;
        idxView.resultImageView.image = [filter imageByFilteringImage:image];
    }
}

@end
