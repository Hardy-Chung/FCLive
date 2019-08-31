//
//  UIColor+Category.h
//  KaraLive
//
//  Created by Zhijia Zhong on 2018/9/12.
//  Copyright © 2018年 naxigoren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)

+ (UIColor *)colorWithRGB:(NSUInteger)rgb;
+ (UIColor *)colorWithRGB:(NSUInteger)rgbValue alpha:(CGFloat)alpha;

@end
