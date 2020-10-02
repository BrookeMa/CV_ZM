//
//  UIApplication+ZMTools.m
//  Pods
//
//  Created by Chin on 2018/8/29.
//

#import "UIApplication+ZMTools.h"

@implementation UIApplication (ZMTools)

#pragma mark 获取栈顶VC
+ (UIViewController *)zmTopViewController
{
    UIViewController * resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController)
    {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
