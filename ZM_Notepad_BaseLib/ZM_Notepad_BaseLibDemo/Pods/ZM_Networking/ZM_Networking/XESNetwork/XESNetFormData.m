//
//  XESNetFormData.m
//  XESNetwork
//
//  Created by 徐强 on 17/6/9.
//  Copyright © 2017年 徐强. All rights reserved.
//

#import "XESNetFormData.h"

@implementation XESNetFormData

+(XESNetFormData *)formDataWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)filename mimeType:(NSString *)mimetype{
    XESNetFormData *formData = [[self alloc] init];
    formData.data = data == nil?[NSData new]:data;
    formData.name = name == nil?@"":name;
    formData.filename = filename == nil?@"":filename;
    formData.mimeType = mimetype == nil?@"":mimetype;
    return formData;
}

@end
