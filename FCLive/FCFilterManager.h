//
//  FCFilterManager.h
//  FCLive
//
//  Created by Zhijia Zhong on 2019/9/25.
//  Copyright © 2019 Zhijia Zhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage/GPUImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCFilterManager : NSObject

@property (nonatomic, strong, readonly) NSArray *allFilters;

+ (instancetype)defaultManager;

@end

NS_ASSUME_NONNULL_END
