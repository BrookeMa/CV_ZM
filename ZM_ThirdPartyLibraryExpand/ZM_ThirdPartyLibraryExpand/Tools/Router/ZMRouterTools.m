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
#import <JLRoutes/JLRRouteDefinition.h>
#import <objc/runtime.h>

static char zm_routerInfo;

static NSMutableDictionary<NSString *,NSString *> * _clsDic = nil;

@interface ZMRouterTools ()

@end

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

+ (void)initRouterWithPlistName:(NSString *)name
                     withScheme:(NSString *)schename
      withGetNavControllerBlock:(UINavigationController *(^)(void))getNavControllerBlock
{
    [self registerRoutersForScheme:schename withPlistName:name withGetNavControllerBlock:getNavControllerBlock];
}

+ (void)registerRoutersForScheme:(NSString *)schename
                   withPlistName:(NSString *)plistName
       withGetNavControllerBlock:(UINavigationController *(^)(void))getNavControllerBlock
{
    _clsDic = [NSMutableDictionary dictionaryWithCapacity:10];
    ZMRouterPath * path = [ZMRouterPath sharedInstance];
    NSArray<ZMRouterModel *> * routerArray = [path getRouterListWithPlistName:plistName];
    for (ZMRouterModel * model in routerArray) {
        NSURL * url = [NSURL URLWithString:model.url];
        JLRoutes * routes = [JLRoutes routesForScheme:url.scheme];
        NSString * newScheme = [url.scheme stringByAppendingString:@"://"];
        NSString * path = [url.absoluteString stringByReplacingOccurrencesOfString:newScheme withString:@"/"];
        
        Class cls = NSClassFromString(model.className);
        NSNumber * displayMode = model.displayMode;
        if(cls != nil && [cls isKindOfClass:[NSNull class]] == NO) {
            id handlerBlock = nil;
            if (displayMode != nil && displayMode.integerValue == 1) {
                //设置绑定关系
                handlerBlock = [JLRRouteHandler handlerBlockForTargetClass:cls completion:^BOOL(id<JLRRouteHandlerTarget>  _Nonnull createdObject) {
                    if(createdObject) {
//                        UINavigationController * nav = getNavControllerBlock();
//                        [nav presentViewController:createdObject animated:model.animated completion:nil];
                        
                        UIViewController * topRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
                        while (topRootVC.presentedViewController) {
                            topRootVC = topRootVC.presentedViewController;
                        }
                        [topRootVC presentViewController:createdObject animated:model.animated completion:nil];
                        
                        
                    }
                    return YES;
                }];
            }else {
                //设置绑定关系
                handlerBlock = [JLRRouteHandler handlerBlockForTargetClass:cls completion:^BOOL(id<JLRRouteHandlerTarget>  _Nonnull createdObject) {
                    if(createdObject) {
                        if (getNavControllerBlock == nil) {
                            [[UIViewController zm_currentNavigationViewController] pushViewController:createdObject animated:model.animated];
                        }else {
                            UINavigationController * nav = getNavControllerBlock();
                            [nav pushViewController:createdObject animated:model.animated];
                        }
                    
                    }
                    return YES;
                }];
            }

            //注册路由
            [routes addRoute:path handler:handlerBlock];
            [_clsDic setObject:model.className forKey:path];
        }
    }
}

+ (void)registerRoutersForScheme:(NSString *)schename withPlistName:(NSString *)plistName
{
    return [self registerRoutersForScheme:schename withPlistName:plistName withGetNavControllerBlock:nil];
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

#pragma mark 路由相关

+ (BOOL)canOpenURL:(NSString *)urlStr
{
    NSURL * url = [NSURL URLWithString:urlStr];
    return [JLRoutes canRouteURL:url];
}

+ (void)pushURL:(NSString *)urlStr
{
    if([ZMRouterTools canOpenURL:urlStr]) {
        NSURL * url = [NSURL URLWithString:urlStr];
        [JLRoutes routeURL:url];
    }
}

+ (void)pushURL:(NSString *)urlStr withParameters:(NSDictionary<NSString *,id> *)parameters
{
    if([ZMRouterTools canOpenURL:urlStr]) {
        NSURL * url = [NSURL URLWithString:urlStr];
        [JLRoutes routeURL:url withParameters:parameters];
    }
}

+ (void)pushFormUrl:(NSString *)urlStr
{
    if (urlStr.length > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        double delayInSeconds = 0;//1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSURL * url = [NSURL URLWithString:urlStr];
            [JLRoutes routeURL:url];
        });
    }
}

+ (void)pushFormUrl:(NSString *)url withParameters:(NSDictionary<NSString *,id> *)parameters
{
    if (url.length > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        double delayInSeconds = 0;// 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        __weak typeof(self) weakSelf = self;
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf pushURL:url withParameters:parameters];
        });
    }
}

+ (id<JLRRouteHandlerTarget>)createViewControllerFromUrl:(NSString *)urlStr withScheme:(NSString *)scheme
{
    if (urlStr.length > 0) {
        
        NSURL * url = [NSURL URLWithString:urlStr];
        NSString * newScheme = [url.scheme stringByAppendingString:@"://"];
        NSString * path = [url.absoluteString stringByReplacingOccurrencesOfString:newScheme withString:@"/"];
        NSURLComponents * components = [[NSURLComponents alloc] initWithString:urlStr];
        NSMutableDictionary * dic    = [NSMutableDictionary dictionaryWithCapacity:10];
        for (NSURLQueryItem * item in components.queryItems) {
            [dic setObject:item.value forKey:item.name];
        }
        if (url.query) {    //存在参数，需要净化URL
            path = [path stringByReplacingOccurrencesOfString:url.query withString:@""];
            path = [path stringByReplacingOccurrencesOfString:@"?" withString:@""];
        }
        JLRoutes * routes = [JLRoutes routesForScheme:scheme];
        for (JLRRouteDefinition * obj in routes.routes) {
            if ([path isEqualToString:obj.pattern]) {
                Class targetClass = NSClassFromString([_clsDic objectForKey:obj.pattern]);
                NSParameterAssert([targetClass conformsToProtocol:@protocol(JLRRouteHandlerTarget)]);
                NSParameterAssert([targetClass instancesRespondToSelector:@selector(initWithRouteParameters:)]);
                id <JLRRouteHandlerTarget> createdObject = [[targetClass alloc] initWithRouteParameters:dic];
                return createdObject;
            }
        }
    }
    return nil;
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
    [ZMRouterTools pushURL:urlStr];
}

- (void)pushURL:(NSString *)urlStr withParameters:(NSDictionary<NSString *,id> *)parameters
{
    [ZMRouterTools pushURL:urlStr withParameters:parameters];
}

- (void)pushFormUrl:(NSString *)urlStr
{
    [ZMRouterTools pushFormUrl:urlStr];
}

- (void)pushFormUrl:(NSString *)url withParameters:(NSDictionary<NSString *,id> *)parameters
{
    [ZMRouterTools pushFormUrl:url withParameters:parameters];
}

#pragma clang diagnostic ignored "-Wobjc-designated-initializers" //清除编译器警告
- (instancetype)initWithRouteParameters:(NSDictionary <NSString *, id> *)parameters
{
    self = [super init];
    if (self) {
//        Protocol * newProtocol = objc_allocateProtocol("JLRRouteHandlerTarget");
//        /* 添加遵守的协议 */
//        protocol_addProtocol(newProtocol, @protocol(NSObject));
//        /* 注册新协议 */
//        objc_registerProtocol(newProtocol);
//        NSLog(@"难不成走的是这个?");
        self.routerInfo = [parameters copy]; // hold on to do something with later on
    }
    return self;
}

@end


