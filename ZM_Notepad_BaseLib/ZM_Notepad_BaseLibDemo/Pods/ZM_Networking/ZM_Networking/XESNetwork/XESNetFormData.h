//
//  XESNetFormData.h
//  XESNetwork
//
//  Created by 徐强 on 17/6/9.
//  Copyright © 2017年 徐强. All rights reserved.
//

/*****************************************
            上传文件FormData
 ******************************************/


#import <Foundation/Foundation.h>

@interface XESNetFormData : NSObject
/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *data;

/**
 *  参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 初始化类方法

 @param data 文件数据
 @param name 参数名
 @param filename 文件名
 @param mimetype 文件类型
 @return XESNetFormData
 */
+(XESNetFormData *)formDataWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)filename mimeType:(NSString *)mimetype;
@end
