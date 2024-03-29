//
//  FCRecordViewController.m
//  FCLive
//
//  Created by Zhijia Zhong on 2019/8/30.
//  Copyright © 2019 Zhijia Zhong. All rights reserved.
//

#import "FCRecordViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIColor+Category.h"

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

// 摄像头类型
@property (nonatomic, strong) NSArray *cameraDeviceTypes;

// 聚焦框视图
@property (nonatomic, strong) UIView *focusView;

@property (nonatomic, assign) AVCaptureDevicePosition position;
@property (nonatomic, assign) NSInteger positionIndex;

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

- (NSArray *)cameraDeviceTypes {
    if (!_cameraDeviceTypes) {
        if (@available(iOS 10.0, *)) {
            NSMutableArray *types = [@[AVCaptureDeviceTypeBuiltInWideAngleCamera, AVCaptureDeviceTypeBuiltInTelephotoCamera] mutableCopy];
            
            if (@available(iOS 10.2, *)) {
                [types addObject:AVCaptureDeviceTypeBuiltInDualCamera];
            } else {
                [types addObject:AVCaptureDeviceTypeBuiltInDuoCamera];
            }
            
            // 深感摄像头，是一个前置摄像头，典型应用有Face ID
            // 以及iMessage里面的Animoji
            //if (@available(iOS 11.1, *)) {
            //    [types addObject:AVCaptureDeviceTypeBuiltInTrueDepthCamera];
            //}
            
            _cameraDeviceTypes = [types copy];
        }
    }
    return _cameraDeviceTypes;
}

- (UIView *)focusView {
    if (!_focusView) {
        _focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _focusView.layer.borderWidth = 0.5;
        _focusView.layer.borderColor = [UIColor colorWithRGB:0x77ebe2].CGColor;
        _focusView.alpha = 0;
    }
    return _focusView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.positionIndex = -1;
    
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
    if (@available(iOS 10.0, *)) {
        self.position = position;
        self.positionIndex += 1;
        AVCaptureDeviceDiscoverySession *s = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:self.cameraDeviceTypes mediaType:AVMediaTypeVideo position:position];
        if (self.positionIndex < s.devices.count) {
            return s.devices[self.positionIndex];
        } else {
            AVCaptureDevicePosition position = 3 - self.position;
            self.positionIndex = -1;
            return [self getVideoDevice:position];
        }
    } else {
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices) {
            if (device.position == position) {
                return device;
            }
        }
        return nil;
    }
}

- (IBAction)didClickTrunButton:(UIButton *)sender {
    [self.captureSession stopRunning];
    [self.captureSession removeInput:self.videoDeviceInput];
    AVCaptureDevice *device = [self getVideoDevice:self.position];
    self.videoDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
    if ([self.captureSession canAddInput:self.videoDeviceInput]) {
        [self.captureSession addInput:self.videoDeviceInput];
        [self.captureSession startRunning];
    }
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if ([output isMemberOfClass:[AVCaptureVideoDataOutput class]]) {
//        NSLog(@"采集到视频数据");
    } else if ([output isMemberOfClass:[AVCaptureAudioDataOutput class]]) {
//        NSLog(@"采集到音频数据");
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 获取点击位置
    CGPoint location = [touches.anyObject locationInView:self.view];
    
    // 转换为摄像头聚焦位置
    CGPoint cameraPoint = [self.videoPreviewLayer captureDevicePointOfInterestForPoint:location];
    
    // 聚焦
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
    
    // 显示焦点框
    [self updateFocusViewWithPoint:location];
}

// 更新焦点
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point {
    AVCaptureDevice *device = self.videoDeviceInput.device;
    
    // 修改配置前需要锁定设备
    [device lockForConfiguration:nil];
    
    // 修改聚聚
    if (device.focusMode != focusMode && [device isFocusModeSupported:focusMode]) {
        [device setFocusMode:focusMode];
    }
    if (device.isFocusPointOfInterestSupported) {
        [device setFocusPointOfInterest:point];
    }
    
    // 修改曝光
    if (device.exposureMode != exposureMode && [device isExposureModeSupported:exposureMode]) {
        [device setExposureMode:exposureMode];
    }
    if (device.isExposurePointOfInterestSupported) {
        [device setExposurePointOfInterest:point];
    }
    
    // 修改完记得解锁
    [device unlockForConfiguration];
}

// 显示焦点框
- (void)updateFocusViewWithPoint:(CGPoint)point {
    if (!_focusView.superview) {
        [self.view addSubview:self.focusView];
    }
    
    self.focusView.center = point;
    self.focusView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.focusView.alpha = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.focusView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusView.alpha = 0;
    }];
}

@end
