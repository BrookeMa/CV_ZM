//
//  ZMFileManager.h
//  Pods-ZM_BaseLibDemo
//
//  Created by Chin on 2018/7/25.
//

#import <Foundation/Foundation.h>

@interface ZMFileManager : NSObject

/**
 获取 temporary 路径.

 @return temporary路径.
 */
+ (NSString *)appTempPath;

/**
 获取 Cache 路径.

 @return Library/Caches路径.
 */
+ (NSString *)appCachePath;

/**
 获取 Library 路径.

 @return Library 路径.
 */
+ (NSString *)appLibraryPath;

/**
 获取 Document 路径.

 @return Document 路径.
 */
+ (NSString *)appDocumentsPath;

/**
 判断文件或文件夹路径是否存在.

 @param path 路径.
 @return 存在 or 不存在.
 */
+ (BOOL)fileExistsAtPath:(NSString *)path;

/**
 判断文件或文件夹路径是否存在.

 @param path 路径.
 @param directory 是否是文件夹.
 @return 存在 or 不存在.
 */
+ (BOOL)fileExistsAtPath:(NSString *)path isDirectory:(BOOL *)directory;

/**
 创建文件路径.

 @param aFilePath 需要创建的路径.
 @return 成功 or 失败.
 */
+ (BOOL)createDirectory:(NSString *)aFilePath;

/**
 将指定的路径复制到新路径.

 @param oldPath 旧路径.
 @param newPath 新路径.
 @return 成功 or 失败.
 */
+ (BOOL)copyItemWithPath:(NSString *)oldPath toNewPath:(NSString *)newPath;

/**
 删除文件.

 @param filePath 文件路径.
 @param aError 错误.
 */
+ (void)deleteFileWithPath:(NSString *)filePath error:(NSError **)aError;

/**
 删除指定目录路径下全部文件.
 
 @param directoryPath 目录路径字符串.
 */
+ (void)deleteAllFilesInDirectoryPath:(NSString *)directoryPath;

/**
 删除指定目录路径下全部文件.
 
 @param directoryPath 目录路径字符串.
 @param fileExtension 文件扩展名类型.
 */
+ (void)deleteAllFilesInDirectoryPath:(NSString *)directoryPath fileExtension:(NSString *)fileExtension;

/**
 排除iCloud同步.
 
 @param filePathString 文件、文件夹路径.
 @return 成功 or 失败.
 */
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *) filePathString;



@end
