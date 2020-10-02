//
//  ZMRouterModel.m
//  ZM_ThirdPartyLibraryExpand
//
//  Created by Chin on 2018/8/1.
//

#import "ZMRouterModel.h"

@implementation ZMRouterModel

- (NSString *)className
{
    if (!_className) {
        return @"";
    }
    return _className;
}

+ (ZMRouterModel *)urlRouterKey:(NSString *)url
{
    ZMRouterModel *model = [[ZMRouterModel alloc]init];
    model.url = url;
    return model;
}

@end
