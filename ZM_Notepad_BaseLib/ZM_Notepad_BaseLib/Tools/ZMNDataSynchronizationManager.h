//
//  ZMNDataSynchronizationManager.h
//  ZM_Notepad_BaseLib
//
//  Created by Chin on 2018/9/11.
//

#import <Foundation/Foundation.h>

@interface ZMNDataSynchronizationManager : NSObject

+ (instancetype)shareInstance;

- (void)noteOfSynchronous;

@end
