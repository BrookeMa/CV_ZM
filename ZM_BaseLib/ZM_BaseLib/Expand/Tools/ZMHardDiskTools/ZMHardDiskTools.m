//
//  ZMHardDiskTools.m
//  ZM_BaseLib
//
//  Created by Chin on 2018/7/30.
//

#import "ZMHardDiskTools.h"

@implementation ZMHardDiskTools

+ (NSString *)hardDiskAllSize
{
    NSError * error = nil;
    NSDictionary * systemAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
        return @"0";
    }
    NSString * diskTotalSize = [systemAttributes objectForKey:@"NSFileSystemSize"];
    return diskTotalSize;
}

+ (NSString *)freeSpaceSzie
{
    NSError * error = nil;
    NSDictionary * systemAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
        return @"0";
    }
    NSString * diskFreeSize = [systemAttributes objectForKey:@"NSFileSystemFreeSize"];
    return diskFreeSize;
}

+ (BOOL)isSaveHardDisk:(long long)size
{
    long long spaceSize = [[self freeSpaceSzie] longLongValue] - size;
    return (spaceSize > 0);
}

+ (long long)hardDiskSizeWithfolderPath:(NSString *)folderPath
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator * childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    NSLog(@"文件总大小：%lld 字节", folderSize);
    return folderSize;
}

+ (long long)fileSizeAtPath:(NSString *)path
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]){
        return [[manager attributesOfItemAtPath:path error:nil] fileSize];
    }
    return 0;
}


@end
