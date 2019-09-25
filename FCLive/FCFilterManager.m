//
//  FCFilterManager.m
//  FCLive
//
//  Created by Zhijia Zhong on 2019/9/25.
//  Copyright © 2019 Zhijia Zhong. All rights reserved.
//

#import "FCFilterManager.h"

@interface FCFilterManager ()

@property (nonatomic, strong, readwrite) NSArray *allFilters;

@end

@implementation FCFilterManager

+ (instancetype)defaultManager {
    static FCFilterManager *_defaultManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[FCFilterManager alloc] init];
    });
    return _defaultManager;
}

- (GPUImageBrightnessFilter *)brightnessFilter {
    GPUImageBrightnessFilter *filter = [[GPUImageBrightnessFilter alloc] init];
    filter.brightness = -0.3;
    return filter;
}

- (GPUImageExposureFilter *)exposureFilter {
    GPUImageExposureFilter *filter = [[GPUImageExposureFilter alloc] init];
    filter.exposure = 1;
    return filter;
}

- (GPUImageContrastFilter *)contrastFilter {
    GPUImageContrastFilter *filter = [[GPUImageContrastFilter alloc] init];
    filter.contrast = 3;
    return filter;
}

- (GPUImage3x3ConvolutionFilter *)convolutionFilter {
    GPUImage3x3ConvolutionFilter *filter = [[GPUImage3x3ConvolutionFilter alloc] init];
    filter.convolutionKernel = (GPUMatrix3x3){
        {-4, -3, -2},
        {-1, 1, 1},
        {2, 3, 4},
    };
    return filter;
}

- (NSArray *)allFilters {
    if (!_allFilters) {
        NSMutableArray *filters = [NSMutableArray array];
        [filters addObject:[self brightnessFilter]];
        [filters addObject:[self exposureFilter]];
        [filters addObject:[self contrastFilter]];
        [filters addObject:[self convolutionFilter]];
        
        _allFilters = [filters copy];
    }
    return _allFilters;
}

@end
