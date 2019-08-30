//
//  FCRecordViewController.m
//  FCLive
//
//  Created by Zhijia Zhong on 2019/8/30.
//  Copyright © 2019 Zhijia Zhong. All rights reserved.
//

#import "FCRecordViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface FCRecordViewController () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>

// 会话，用于协调输入输出
@property (nonatomic, strong) AVCaptureSession *captureSession;
// 视频输入对象
@property (nonatomic, strong) AVCaptureDeviceInput *videoDeviceInput;
// 音频输入对象
@property (nonatomic, strong) AVCaptureDeviceInput *audioDeviceInput;
// 视频输出对象
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
// 音频输出对象
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioOutput;

// 视频预览图层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation FCRecordViewController

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}

- (AVCaptureDeviceInput *)videoDeviceInput {
    if (!_videoDeviceInput) {
        // 获取前置摄像头，默认是后置摄像头
        AVCaptureDevice *videoDevice = [self getVideoDevice:AVCaptureDevicePositionFront];
        _videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    }
    return _videoDeviceInput;
}

- (AVCaptureDeviceInput *)audioDeviceInput {
    if (!_audioDeviceInput) {
        // 获取麦克风
        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        _audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    }
    return _audioDeviceInput;
}

- (AVCaptureVideoDataOutput *)videoOutput {
    if (!_videoOutput) {
        _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        // 必须使用串行队列
        dispatch_queue_t videoOutputQueue = dispatch_queue_create("FCLive Video Capture Queue", DISPATCH_QUEUE_SERIAL);
        [_videoOutput setSampleBufferDelegate:self queue:videoOutputQueue];
    }
    return _videoOutput;
}

- (AVCaptureAudioDataOutput *)audioOutput {
    if (!_audioOutput) {
        _audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        // 必须使用串行队列
        dispatch_queue_t audioOutputQueue = dispatch_queue_create("FCLive Audio Capture Queue", DISPATCH_QUEUE_SERIAL);
        [_audioOutput setSampleBufferDelegate:self queue:audioOutputQueue];
    }
    return _audioOutput;
}

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer {
    if (!_videoPreviewLayer) {
        _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        _videoPreviewLayer.frame = self.view.bounds;
    }
    return _videoPreviewLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 绑定视频输入设备
    if ([self.captureSession canAddInput:self.videoDeviceInput]) {
        [self.captureSession addInput:self.videoDeviceInput];
    }
    
    // 绑定音频输入设备
    if ([self.captureSession canAddInput:self.audioDeviceInput]) {
        [self.captureSession addInput:self.audioDeviceInput];
    }
    
    // 绑定视频输出
    if ([self.captureSession canAddOutput:self.videoOutput]) {
        [self.captureSession addOutput:self.videoOutput];
    }
    
    // 绑定音频输出
    if ([self.captureSession canAddOutput:self.audioOutput]) {
        [self.captureSession addOutput:self.audioOutput];
    }
    
    // 视频预览
    [self.view.layer insertSublayer:self.videoPreviewLayer atIndex:0];
    
    // 启动会话
    [self.captureSession startRunning];
}

// 获取指定方向摄像头
- (AVCaptureDevice *)getVideoDevice:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

@end
