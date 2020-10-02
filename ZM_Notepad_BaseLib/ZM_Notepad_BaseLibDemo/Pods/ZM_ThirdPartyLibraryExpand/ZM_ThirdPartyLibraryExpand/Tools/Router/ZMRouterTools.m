//
//  ZMRouterTools.m
//  ZM_ThirdPartyLibraryExpand
//
//  Created by Chin on 2018/8/1.
//

#import "ZMRouterTools.h"
#import "ZMRouterPath.h"
#import "ZMRouterModel.h"
#import <JLRoutes/JLRoutes.h>
#import <JLRoutes/JLRRouteHandler.h>
#import <objc/runtime.h>

static char zm_routerInfo;

@implementation ZMRouterTools

+ (void)initRouterWithScheme:(NSString *)schename
{
//    __weak typeof(self) weakSelf = self;  
    NSString * name = [ZMRouterPath sharedInstance].configName;
    [self registerRoutersForScheme:schename withPlistName:name];
}

+ (void)initRouterWithPlistName:(NSString *)name withScheme:(NSString *)schename
{
    [self registerRoutersForScheme:schename withPlistName:name];
}

+ (void)registerRoutersForScheme:(NSString *)schename withPlistName:(NSString *)plistName
{
//    JLRoutes * routes = [JLRoutes routesForScheme:schename];
    ZMRouterPath * path = [ZMRouterPath sharedInstance];
    NSArray<ZMRouterModel *> * routerArray = [path getRouterListWithPlistName:plistName];
    for (ZMRouterModel * model in routerArray) {
        NSURL * url = [NSURL URLWithString:model.url];
        JLRoutes * routes = [JLRoutes routesForScheme:url.scheme];
        NSString * newScheme = [url.scheme stringByAppendingString:@"://"];
        NSString * path = [url.absoluteString stringByReplacingOccurrencesOfString:newScheme withString:@"/"];
        
        Class cls = NSClassFromString(model.className);
        if(cls != nil && [cls isKindOfClass:[NSNull class]] == NO) {
            //设置绑定关系
            id handlerBlock = [JLRRouteHandler handlerBlockForTargetClass:cls completion:^BOOL(id<JLRRouteHandlerTarget>  _Nonnull createdObject) {
                if(createdObject) {
                    [[UIViewController zm_currentNavigationViewController] pushViewController:createdObject animated:YES];
                }
                return YES;
            }];
            //注册路由
            [routes addRoute:path handler:handlerBlock];
        }
    }
}

+ (NSDictionary *)getParamtersFromURL:(NSString *)url
{
    NSURLComponents * urlComponents    = [NSURLComponents componentsWithString:url];
    NSMutableDictionary * queryItemDic = [NSMutableDictionary dictionary];
    for (NSURLQueryItem * item in urlComponents.queryItems) {
        [queryItemDic setObject:item.value forKey:item.name];
    }
    return [queryItemDic copy];
}

@end


@implementation UIViewController (ZMRouterTool)

+ (UIViewController *)zm_currentViewController
{
    UIViewController * rootViewController = self.zm_applicationDelegate.window.rootViewController;
    return [self zm_currentViewControllerFrom:rootViewController];
}

+ (UINavigationController *)zm_currentNavigationViewController
{
    UIViewController * currentViewController = [self zm_currentViewController];
    return currentViewController.navigationController;
}

+ (id<UIApplicationDelegate>)zm_applicationDelegate
{
    return [UIApplication sharedApplication].delegate;
}

/** 递归拿到当控制器 */
+ (UIViewController *)zm_currentViewControllerFrom:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController * navigationController = (UINavigationController *)viewController;
        return [self zm_currentViewControllerFrom:navigationController.viewControllers.lastObject];
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController * tableBarController = (UITabBarController *)viewController;
        return [self zm_currentViewControllerFrom:tableBarController.selectedViewController];
    } else if (viewController.presentedViewController != nil) {
        return [self zm_currentViewControllerFrom:viewController.presentedViewController];
    } else {
        return viewController;
    }
}

#pragma mark - routerInfo
- (NSDictionary *)routerInfo
{
    return objc_getAssociatedObject(self, &zm_routerInfo);
}

- (void)setRouterInfo:(NSDictionary *)routerInfo
{
    objc_setAssociatedObject(self, &zm_routerInfo, routerInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)canOpenURL:(NSString *)urlStr
{
    NSURL * url = [NSURL URLWithString:urlStr];
    return [JLRoutes canRouteURL:url];
}

- (void)pushURL:(NSString *)urlStr
{
    if([self canOpenURL:urlStr]) {
        NSURL * url = [NSURL URLWithString:urlStr];
        [JLRoutes routeURL:url];
    }
}

- (void)pushURL:(NSString *)urlStr withParameters:(NSDictionary<NSString *,id> *)parameters
{
    if([self canOpenURL:urlStr]) {
        NSURL * url = [NSURL URLWithString:urlStr];
        [JLRoutes routeURL:url withParameters:parameters];
    }
}

- (void)pushFormUrl:(NSString *)urlStr
{
    if (urlStr.length > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSURL * url = [NSURL URLWithString:urlStr];
            [JLRoutes routeURL:url];
        });
    }
}

- (void)pushFormUrl:(NSString *)url withParameters:(NSDictionary<NSString *,id> *)parameters
{
    if (url.length > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        __weak typeof(self) weakSelf = self;
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf pushURL:url withParameters:parameters];
        });
    }
}

@end


