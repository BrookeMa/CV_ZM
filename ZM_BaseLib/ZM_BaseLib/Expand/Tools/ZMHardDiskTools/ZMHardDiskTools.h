//
//  ZMHardDiskTools.h
//  ZM_BaseLib
//
//  Created by Chin on 2018/7/30.
//

#import <Foundation/Foundation.h>

@interface ZMHardDiskTools : NSObject

/**
 硬盘总大小
 
 @return 字节
 */
+ (NSString *)hardDiskAllSize;

/**
 可用空间大小
 
 @return 字节
 */
+ (NSString *)freeSpaceSzie;

/**
 硬盘空间是否可以存储
 
 @param size 字节格式
 @return 返回是否可以
 */
+ (BOOL)isSaveHardDisk:(long long)size;

/**
 指定路径文件夹大小
 
 @param folderPath 文件夹路径
 @return 字节
 */
+ (long long)hardDiskSizeWithfolderPath:(NSString *)folderPath;

/**
 指定路径文件大小
 
 @param path 路径
 @return 字节
 */
+ (long long)fileSizeAtPath:(NSString *)path;

@end
