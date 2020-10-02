//
//  NSString+ZMTools.h
//  ZM_BaseLib
//
//  Created by Chin on 2018/7/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (ZMTools)

/**
 字符串根据字体和展示范围计算size
 
 @param font 字体
 @param size size
 @param lineBreakMode 折行方式
 @return size
 */
- (CGSize)zm_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

/**
 字符串根据字体和展示范围计算size
 
 @param font 字体
 @param size size
 @param lineBreakMode 折行方式
 @param spacing 行间距
 @return size
 */
- (CGSize)zm_sizeForFont:(UIFont *)font
                    size:(CGSize)size
                    mode:(NSLineBreakMode)lineBreakMode
             lineSpacing:(CGFloat)spacing;

/**
 字符串根据字体和宽度 计算高度
 适用于 多行文本显示计算
 @param font 字体
 @param width 宽度
 @return 高度值
 */
- (CGFloat)zm_heightForFont:(UIFont *)font width:(CGFloat)width;

/**
 字符串根据字体 计算宽度
 适用于 单行文本显示计算
 
 @param font 字体
 @return 宽度
 */
- (CGFloat)zm_widthForFont:(UIFont *)font;

@end
