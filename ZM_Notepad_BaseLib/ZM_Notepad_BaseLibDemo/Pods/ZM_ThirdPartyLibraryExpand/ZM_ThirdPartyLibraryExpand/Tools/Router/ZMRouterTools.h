//
//  ZMRouterTools.h
//  ZM_ThirdPartyLibraryExpand
//
//  Created by Chin on 2018/8/1.
//

#import <Foundation/Foundation.h>
#import <JLRoutes/JLRRouteHandler.h>

@interface ZMRouterTools : NSObject

+ (void)initRouterWithScheme:(NSString *)schename;

/**
 初始化路由配置

 @param name 配置表名字
 @param schename Schename名字
 */
+ (void)initRouterWithPlistName:(NSString *)name withScheme:(NSString *)schename;

/**
 获取URL中的参数
 
 @param url URL字符串
 @return 参数Map(Key,Value形式)
 */
+ (NSDictionary *)getParamtersFromURL:(NSString *)url;

@end



@interface UIViewController (ZMRouterTool)

/**
 Router参数字典
 */
@property (nonatomic, copy) NSDictionary <NSString *, id> * routerInfo;

/**
 获取栈顶ViewController.

 @return VC.
 */
+ (UIViewController *)zm_currentViewController;

/**
 获取栈顶NavigationViewController.

 @return NavigationViewController.
 */
+ (UINavigationController *)zm_currentNavigationViewController;

/**
 是否可以打开界面.

 @param urlStr 校验URL.
 @return 是否可以打开.
 */
- (BOOL)canOpenURL:(NSString *)urlStr;

/**
 跳转路由路径-外部调用延时1S(无参)
 
 @param urlStr URL.
 */
- (void)pushFormUrl:(NSString *)urlStr;

/**
 跳转路由路径-外部调用延时1S(有参数)
 
 @param urlStr URL.
 @param parameters 参数字典.
 */
- (void)pushFormUrl:(NSString *)urlStr withParameters:(NSDictionary<NSString *,id> *)parameters;



@end
