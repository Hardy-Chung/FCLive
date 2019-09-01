//
//  FCGPURecordViewController.m
//  FCLive
//
//  Created by Sergeant on 2019/9/1.
//  Copyright © 2019 Zhijia Zhong. All rights reserved.
//

#import "FCGPURecordViewController.h"
#import <GPUImage/GPUImage.h>

@interface FCGPURecordViewController ()

// 视频源
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
// 预览view
@property (nonatomic, strong) GPUImageView *videoPreview;
// 滤镜组
@property (nonatomic, strong) GPUImageFilterGroup *filterGroup;
// 磨皮滤镜
@property (nonatomic, strong) GPUImageBilateralFilter *bilateralFilter;
// 美白滤镜
@property (nonatomic, strong) GPUImageBrightnessFilter *brightnessFilter;

@end

@implementation FCGPURecordViewController

- (GPUImageVideoCamera *)videoCamera {
    if (!_videoCamera) {
        // 创建视频源
        // SessionPreset: 屏幕分辨率，AVCaptureSessionPresetHigh会自适应高分辨率
        // cameraPosition: 摄像头方向
        _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
        _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    }
    return _videoCamera;
}

- (GPUImageView *)videoPreview {
    if (!_videoPreview) {
        // 创建预览视图
        _videoPreview = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    }
    return _videoPreview;
}

- (GPUImageFilterGroup *)filterGroup {
    if (!_filterGroup) {
        _filterGroup = [[GPUImageFilterGroup alloc] init];
    }
    return _filterGroup;
}

- (GPUImageBilateralFilter *)bilateralFilter {
    if (!_bilateralFilter) {
        _bilateralFilter = [[GPUImageBilateralFilter alloc] init];
    }
    return _bilateralFilter;
}

- (GPUImageBrightnessFilter *)brightnessFilter {
    if (!_brightnessFilter) {
        _brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    }
    return _brightnessFilter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view insertSubview:self.videoPreview atIndex:0];
    
//    [self.filterGroup addTarget:self.bilateralFilter];
//    [self.filterGroup addTarget:self.brightnessFilter];
    [self.bilateralFilter addTarget:self.brightnessFilter];
    [self.filterGroup setInitialFilters:@[self.bilateralFilter]];
    self.filterGroup.terminalFilter = self.brightnessFilter;
    
    [self.videoCamera addTarget:self.filterGroup];
    [self.filterGroup addTarget:self.videoPreview];
    
    [self.videoCamera startCameraCapture];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.videoPreview.frame = self.view.bounds;
}

@end
