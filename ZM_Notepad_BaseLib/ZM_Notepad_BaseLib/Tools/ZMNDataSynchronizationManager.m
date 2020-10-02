//
//  ZMNDataSynchronizationManager.m
//  ZM_Notepad_BaseLib
//
//  Created by Chin on 2018/9/11.
//

#import "ZMNDataSynchronizationManager.h"

#import "ZMNDataBaseManager.h"

@interface ZMNDataSynchronizationManager ()

@end

@implementation ZMNDataSynchronizationManager

+ (instancetype)shareInstance
{
    static ZMNDataSynchronizationManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZMNDataSynchronizationManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)noteOfSynchronous
{
//    [ZMNDataBaseManager shareInstance]
//    if (<#condition#>) {
//        <#statements#>
//    }
    
    
}

@end
