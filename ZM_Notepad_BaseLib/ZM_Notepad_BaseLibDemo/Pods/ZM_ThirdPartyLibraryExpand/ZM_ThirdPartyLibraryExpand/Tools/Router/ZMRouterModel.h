//
//  ZMRouterModel.h
//  ZM_ThirdPartyLibraryExpand
//
//  Created by Chin on 2018/8/1.
//

#import <Foundation/Foundation.h>

@interface ZMRouterModel : NSObject

@property (nonatomic, strong) NSString * describe;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * className;

+ (ZMRouterModel *)urlRouterKey:(NSString *)url;

@end
