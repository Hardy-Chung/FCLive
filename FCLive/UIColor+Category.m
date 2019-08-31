//
//  UIColor+Category.m
//  KaraLive
//
//  Created by Zhijia Zhong on 2018/9/12.
//  Copyright © 2018年 naxigoren. All rights reserved.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)

+ (UIColor *)colorWithRGB:(NSUInteger)rgbValue {
    return [UIColor colorWithRGB:rgbValue alpha:1.0];
}

+ (UIColor *)colorWithRGB:(NSUInteger)rgbValue alpha:(CGFloat)alpha {
    CGFloat red = ((rgbValue & 0xFF0000) >> 16) / 255.0;
    CGFloat green = (((rgbValue & 0xFF00) >> 8)) / 255.0;
    CGFloat blue = (rgbValue & 0xFF) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
