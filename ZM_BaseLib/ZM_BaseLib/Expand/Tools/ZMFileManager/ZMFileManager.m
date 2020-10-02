//
//  ZMFileManager.m
//  Pods-ZM_BaseLibDemo
//
//  Created by Chin on 2018/7/25.
//

#import "ZMFileManager.h"

@implementation ZMFileManager

+ (NSString *)appDocumentsPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)appLibraryPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)appCachePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)appTempPath
{
    return NSTemporaryDirectory();
}

+ (BOOL)fileExistsAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)fileExistsAtPath:(NSString *)path isDirectory:(BOOL *)directory
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:directory];
}

+ (BOOL)createDirectory:(NSString *)aFilePath
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:aFilePath]) {
        return YES;
    }
    return [fileManager createDirectoryAtPath:aFilePath withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (BOOL)copyItemWithPath:(NSString *)oldPath toNewPath:(NSString *)newPath
{
    if (oldPath.length == 0 || newPath.length == 0) {
        return NO;
    }
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:oldPath]) {
        return [fileManager copyItemAtPath:oldPath toPath:newPath error:nil];
    }
    return NO;
}

+ (void)deleteFileWithPath:(NSString *)filePath error:(NSError **)aError
{
    if (filePath.length == 0) {
        return;
    }
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:aError];
    }
}

+ (void)deleteAllFilesInDirectoryPath:(NSString *)directoryPath
{
    [[self class] deleteAllFilesInDirectoryPath:directoryPath fileExtension:nil];
}

+ (void)deleteAllFilesInDirectoryPath:(NSString *)directoryPath fileExtension:(NSString *)fileExtension
{
    if (directoryPath.length > 0) {
        NSFileManager * fileManager = [NSFileManager defaultManager];
        //列出目录
        NSArray * contents = [fileManager contentsOfDirectoryAtPath:directoryPath error:nil];
        NSLog(@"contents = %@", contents);
        //目录不为空
        if (contents.count > 0) {
            //遍历目录删除
            [contents enumerateObjectsUsingBlock:^(NSString * _Nonnull filename, NSUInteger idx, BOOL * _Nonnull stop) {
                if (fileExtension.length > 0) {
                    if ([[filename pathExtension] isEqualToString:fileExtension]) {
                        [fileManager removeItemAtPath:[directoryPath stringByAppendingPathComponent:filename] error:nil];
                    }
                }
                else {
                    [fileManager removeItemAtPath:[directoryPath stringByAppendingPathComponent:filename] error:nil];
                }
            }];
        }
    }
}

+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *) filePathString
{
    NSURL * URL = [NSURL fileURLWithPath: filePathString];
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError * error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}



@end
