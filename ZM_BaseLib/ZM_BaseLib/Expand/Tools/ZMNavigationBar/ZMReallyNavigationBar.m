//
//  ZMReallyNavigationBar.m
//  NewInformationProject
//
//  Created by 毛立 on 2018/3/30.
//  Copyright © 2018年 上海展盟. All rights reserved.
//

#import "ZMReallyNavigationBar.h"

@implementation ZMReallyNavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([UIScreen mainScreen].bounds.size.height == 812) {
        self.frame = CGRectMake(0, 24, [UIScreen mainScreen].bounds.size.width, 64);
    }else{
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    for (UIView *view in self.subviews) {
        if([NSStringFromClass([view class]) containsString:@"Background"]) {
            view.frame = self.bounds;
        }
        else if ([NSStringFromClass([view class]) containsString:@"ContentView"]) {
            CGRect frame = view.frame;
            frame.origin.y = 20;
            frame.size.height = self.bounds.size.height - frame.origin.y;
            view.frame = frame;
        }
    }
}

@end
