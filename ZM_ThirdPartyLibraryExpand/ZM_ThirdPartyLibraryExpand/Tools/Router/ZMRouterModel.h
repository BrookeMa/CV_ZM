//
//  ZMRouterModel.h
//  ZM_ThirdPartyLibraryExpand
//
//  Created by Chin on 2018/8/1.
//

#import <Foundation/Foundation.h>

@interface ZMRouterModel : NSObject


@property (nonatomic, strong) NSNumber * displayMode;//0:push 1:present
@property (nonatomic, strong) NSString * describe;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * className;
@property (nonatomic, assign) BOOL animated;

+ (ZMRouterModel *)urlRouterKey:(NSString *)url;

@end
