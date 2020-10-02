//
//  ZMMResponseCheckTool.h
//  ZM_Notepad_BaseLib
//
//  Created by Chin on 2018/8/31.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZMNCheckReuqstState) {
    ZMNCheckReuqstState_message,///< 自带消息
    ZMNCheckReuqstState_customMessage = -1,///< 自定义消息提示
};

@interface ZMNResponseCheckTool : NSObject

@property (nonatomic, strong, readonly) id responseData;
@property (nonatomic, strong, readonly) NSNumber * code;
@property (nonatomic, strong, readonly) id data;
@property (nonatomic, strong, readonly) NSString * msg;
@property (nonatomic, strong, readonly) NSString * show_msg;
@property (nonatomic, strong, readonly) NSString * time;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


/**
 对成功数据的处理
 
 @return tool
 */
+ (ZMNResponseCheckTool *)checkDataWithResponseData:(id)responseData;
/**
 对失败数据的处理
 
 @return tool
 */
+ (ZMNResponseCheckTool *)checkDataWithFailureResponseData:(id)responseData;
/**
 对失败数据的处理
 
 @return tool
 */
+ (ZMNResponseCheckTool *)checkDataWithFailureResponseError:(NSError *)error;

/**
 成功验证
 
 @return 是否成功
 */
- (BOOL)successfulCode;

- (ZMNCheckReuqstState)checkCustomMessgae;

@end
