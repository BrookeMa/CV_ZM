//
//  UIColor+ZMTools.h
//  ZM_BaseLib
//
//  Created by Chin on 2018/7/26.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZMTools)

/**
 RGB色值转UIColor.

 @param hex 举例: 0x4d2915.
 @return UIColor对象.
 */
+ (UIColor *)zm_colorWithHexValue:(u_int32_t)hex;

/**
 RGB色值转UIColor.

 @param hex 举例:0x4d2915.
 @param alpha 值为0.f - 1.f
 @return UIColor对象.
 */
+ (UIColor *)zm_colorWithHexValue:(u_int32_t)hex withAlpha:(CGFloat)alpha;

/**
 随机生成Color.

 @return UIColor对象.
 */
+ (UIColor *)zm_randomColor;


@end
