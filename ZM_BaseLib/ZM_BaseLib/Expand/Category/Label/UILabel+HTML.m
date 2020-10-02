//
//  UILabel+HTML.m
//  HH
//
//  Created by MK on 21/07/2017.
//  Copyright © 2017 hoho. All rights reserved.
//

#import "UILabel+HTML.h"

@implementation UILabel (HTML)

- (void)jaq_setHTMLFromString:(NSString *)string {
    
    const CGFloat *_components = CGColorGetComponents(self.textColor.CGColor);
    int red     = _components[0] * 255;
    int green   = _components[1] * 255;
    int blue    = _components[2] * 255;
    
    string = [string stringByAppendingString:[NSString stringWithFormat:@"<style>body{color: rgb(%i, %i, %i);}</style>",red, green, blue]];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding]
                                                           options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                     NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                documentAttributes:nil
                                                             error:nil];
    
    [attrStr addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attrStr.length)];
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, attrStr.length)];
    self.attributedText = attrStr;
}


@end
