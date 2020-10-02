//
//  UIColor+ZMTools.m
//  ZM_BaseLib
//
//  Created by Chin on 2018/7/26.
//

#import "UIColor+ZMTools.h"

@implementation UIColor (ZMTools)

+ (UIColor *)zm_colorWithHexValue:(u_int32_t)hex
{
    return [UIColor zm_colorWithHexValue:hex withAlpha:1.f];
}

+ (UIColor *)zm_colorWithHexValue:(u_int32_t)hex withAlpha:(CGFloat)alpha
{
    int red   = (hex & 0xFF0000) >> 16;
    int green = (hex & 0x00FF00) >> 8;
    int blue  = (hex & 0x0000FF);
    return [UIColor colorWithRed:(red / 255.f) green:(green / 255.f) blue:(blue / 255.f) alpha:alpha];
}

+ (UIColor *)zm_randomColor
{
    NSInteger red   = arc4random() % 255;
    NSInteger green = arc4random() % 255;
    NSInteger blue  = arc4random() % 255;
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1.0f];
}

@end
