//
//  XESNetworkLog.m
//  XESNetworkDemo
//
//  Created by 徐强 on 17/7/11.
//  Copyright © 2017年 XES. All rights reserved.
//

#import "XESNetworkLog.h"

@implementation XESNetworkLog

+ (NSString *)logWithStartRequest:(XESNetworkBaseRequest *)request{
    NSMutableString *logstring = [NSMutableString string];
    NSString *methodStr = [self methodStrByRequet:request];
       [logstring appendString:[NSString stringWithFormat:@"\n"
                          "----------------------------------------------------------\n"
                          "                     发起请求:%@\n"
                          "请求方式:\n"
                          "             %@\n"
                          "请求URL:\n"
                          "             %@\n"
                          "请求参数:\n"
                          "             %@\n"
                          "----------------------------------------------------------\n"
                          ,request.requestName, methodStr, request.requestUrl , request.requestParams
                          ]];
    NSLog(@"%@", logstring);
    return logstring;
}

+ (NSString *)logWithSuccessRequest:(XESNetworkBaseRequest *)request{
    NSMutableString *logstring = [NSMutableString string];
    NSString *methodStr = [self methodStrByRequet:request];
    NSTimeInterval time = [request.endTime timeIntervalSinceDate:request.startTime];
    [logstring appendString:[NSString stringWithFormat:@"\n"
                          "----------------------------------------------------------\n"
                          "                     完成请求:%@\n"
                          "请求API:\n"
                          "             %@\n"
                          
                          "请求URL:\n"
                          "             %@\n"
                          "接口耗时:\n"
                          "             %.3f毫秒\n"
                          "返回数据:\n"
                          "\n"
                          "%@\n"
                          "\n"
                          "----------------------------------------------------------\n"
                          , request.requestName,methodStr, request.requestUrl,time*1000, request.responseObject
                          ]];
    NSLog(@"%@", logstring);
    return logstring;
}

+ (NSString *)logWithFailureRequest:(XESNetworkBaseRequest *)request{
    NSMutableString *logstring = [NSMutableString string];
    NSString *methodStr = [self methodStrByRequet:request];
    [logstring appendString:[NSString stringWithFormat:@"\n"
                             "----------------------------------------------------------\n"
                             "                  请求错误:\n"
                             "请求API:\n"
                             "             %@\n"
                             
                             "请求URL:\n"
                             "             %@\n"
                             "错误码:\n"
                             "             %ld\n"
                             "错误描述:\n"
                             "             %@\n"
                             "----------------------------------------------------------\n"
                             , methodStr, request.requestUrl, (long)request.responseStatusCode, request.error.localizedDescription
                             ]];
    NSLog(@"%@", logstring);
    return logstring;

}

+(NSString *)methodStrByRequet:(XESNetworkBaseRequest *)request{
    NSString *methodStr;
    switch (request.requestMethod) {
        case XESRequestMethodGET:
            if (request.downloadSavePath) {
                methodStr = @"下载请求";
            }else{
                methodStr = @"GET请求";
            }
            break;
        case XESRequestMethodPOST:
            if (request.requestFormData) {
                methodStr = @"POST请求-表单上传数据";
            }else{
                methodStr = @"POST请求";
            }
            break;
        case XESRequestMethodHEAD:
            methodStr = @"HEAD请求";
            break;
        case XESRequestMethodPUT:
            methodStr = @"PUT请求";
            break;
        case XESRequestMethodDELETE:
            methodStr = @"DELETE请求";
            break;
        case XESRequestMethodPATCH:
            methodStr = @"PATCH请求";
            break;
        default:
            methodStr = @"未知请求类型";
            break;
    }
    return methodStr;
}
@end
