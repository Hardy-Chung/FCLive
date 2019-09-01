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
        _bilateralFilter.distanceNormalizationFactor = 5;
    }
    return _bilateralFilter;
}

- (GPUImageBrightnessFilter *)brightnessFilter {
    if (!_brightnessFilter) {
        _brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
        _brightnessFilter.brightness = 0;
    }
    return _brightnessFilter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view insertSubview:self.videoPreview atIndex:0];
    
    // 设置滤镜组链
    [self.bilateralFilter addTarget:self.brightnessFilter];
    [self.filterGroup setInitialFilters:@[self.bilateralFilter]];
    self.filterGroup.terminalFilter = self.brightnessFilter;
    
    // 设置GPUImage响应链，从数据源 => 滤镜 => 最终界面效果
    [self.videoCamera addTarget:self.filterGroup];
    [self.filterGroup addTarget:self.videoPreview];
    
    [self.videoCamera startCameraCapture];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.videoPreview.frame = self.view.bounds;
}

- (IBAction)bilateralSlider:(UISlider *)sender {
    CGFloat maxValue = 10;
    self.bilateralFilter.distanceNormalizationFactor = maxValue - sender.value;
}

- (IBAction)brightness:(UISlider *)sender {
    self.brightnessFilter.brightness = sender.value;
}

@end
