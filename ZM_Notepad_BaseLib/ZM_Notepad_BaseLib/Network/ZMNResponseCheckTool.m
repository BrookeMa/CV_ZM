//
//  ZMNResponseCheckTool.m
//  ZM_Notepad_BaseLib
//
//  Created by Chin on 2018/8/31.
//

#import "ZMNResponseCheckTool.h"

@interface ZMNResponseCheckTool()

@property (nonatomic, strong)id responseData;

@property (nonatomic, strong, readwrite) NSNumber * code;
@property (nonatomic, strong, readwrite) id data;
@property (nonatomic, strong, readwrite) NSString * msg;
@property (nonatomic, strong, readwrite) NSString * show_msg;
@property (nonatomic, strong, readwrite) NSString * time;

@property (nonatomic, assign)BOOL isRight;

@end

@implementation ZMNResponseCheckTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isRight = NO;
    }
    return self;
}

+ (ZMNResponseCheckTool *)checkDataWithResponseData:(id)responseData
{
    ZMNResponseCheckTool * checkTool = [[self alloc] init];
    checkTool.responseData = responseData;
    return checkTool;
}

+ (ZMNResponseCheckTool *)checkDataWithFailureResponseData:(id)responseData
{
    ZMNResponseCheckTool * checkTool = [[self alloc] init];
    checkTool.responseData = responseData;
    return checkTool;
}

+ (ZMNResponseCheckTool *)checkDataWithFailureResponseError:(NSError *)error
{
    ZMNResponseCheckTool *checkTool =  [[self alloc] init];
    checkTool.code = [NSString stringWithFormat:@"%ld",(long)error.code];
    checkTool.msg  = [error localizedDescription];
    return checkTool;
}

- (BOOL)successfulCode
{
    [self checkData];
    return self.isRight;
}

- (void)checkData
{
    self.data = self.responseData[@"data"];
    self.code = self.responseData[@"err_code"];
    self.msg  = [NSString stringWithFormat:@"%@(%@)",self.responseData[@"err_msg"],self.code];
    
    self.show_msg = self.responseData[@"show_msg"];
    self.time = self.responseData[@"time"];

    if (self.code.integerValue == 200 || self.code.integerValue == 0) {
        self.isRight = YES;
    }
    else{
        self.isRight = NO;
    }
}

- (ZMNCheckReuqstState)checkCustomMessgae
{
    return ZMNCheckReuqstState_customMessage;
}

@end
