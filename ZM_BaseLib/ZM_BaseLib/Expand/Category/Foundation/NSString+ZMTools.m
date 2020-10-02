//
//  NSString+ZMTools.m
//  ZM_BaseLib
//
//  Created by Chin on 2018/7/30.
//

#import "NSString+ZMTools.h"

@implementation NSString (ZMTools)

- (CGSize)zm_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode
{
    CGSize result;
    if (font == nil) font = [UIFont systemFontOfSize:12];

    NSMutableDictionary * attr = [NSMutableDictionary new];
    attr[NSFontAttributeName]  = font;
    if (lineBreakMode != NSLineBreakByWordWrapping) {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = lineBreakMode;
        attr[NSParagraphStyleAttributeName] = paragraphStyle;
    }
    CGRect rect = [self boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attr context:nil];
    result = rect.size;
    return result;
}

- (CGSize)zm_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode lineSpacing:(CGFloat)spacing
{
    CGSize result;
    if (font == nil) font = [UIFont systemFontOfSize:12];
    
    NSMutableDictionary * attr = [NSMutableDictionary new];
    attr[NSFontAttributeName]  = font;
    if (lineBreakMode != NSLineBreakByWordWrapping) 
    {
        NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing   = spacing;//调整行间距
        paragraphStyle.lineBreakMode = lineBreakMode;
        attr[NSParagraphStyleAttributeName] = paragraphStyle;
    }
    CGRect rect = [self boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attr context:nil];
    result = rect.size;
    return  result;
}

- (CGFloat)zm_heightForFont:(UIFont *)font width:(CGFloat)width
{
    CGSize size = [self zm_sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

- (CGFloat)zm_widthForFont:(UIFont *)font
{
    CGSize size = [self zm_sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

@end
