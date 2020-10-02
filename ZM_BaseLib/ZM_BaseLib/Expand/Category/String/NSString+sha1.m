//
//  NSString+sha1.m
//  ZM_BaseLib
//
//  Created by Ye Ma on 2018/9/14.
//

#import "NSString+sha1.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (sha1)

//sha1加密方式
- (NSString *)sha1:(NSString *)input {
    //这两句容易造成 、中文字符串转data时会造成数据丢失
    //const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    //NSData *data = [NSData dataWithBytes:cstr length:input.length];
    //instead of
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

@end
