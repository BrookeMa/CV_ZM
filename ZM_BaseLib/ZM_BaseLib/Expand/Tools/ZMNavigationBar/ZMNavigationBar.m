//
//  ZMNavigationBar.m
//  NewInformationProject
//
//  Created by 毛立 on 2018/3/30.
//  Copyright © 2018年 上海展盟. All rights reserved.
//

#import "ZMNavigationBar.h"
#import "ZMReallyNavigationBar.h"

@interface ZMNavigationBar()
/**
 navBar
 */
@property (nonatomic,strong) ZMReallyNavigationBar *navigationBar;
/**
 UINavigationItem
 */
@property (nonatomic,strong) UINavigationItem *navigationItem;
@end
@implementation ZMNavigationBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height == 812 ? 88 : 64));
        [self addSubview:self.navigationBar];
        //设置字体颜色
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:101/255.0 green:101/255.0 blue:101/255.0 alpha:1]}];
        [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    }
    return self;
}

#pragma mark - 更新
-(void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    self.navigationBar.backgroundColor = backgroundColor;
    self.navigationBar.barTintColor = backgroundColor;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.navigationItem.title = title;
}

-(void)setTitleView:(UIView *)titleView{
    _titleView = titleView;
    self.navigationItem.titleView = titleView;
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    _leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem {
    _rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems {
    _leftBarButtonItems = leftBarButtonItems;
    self.navigationItem.leftBarButtonItems = leftBarButtonItems;
}

- (void)setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems {
    _rightBarButtonItems = rightBarButtonItems;
    self.navigationItem.rightBarButtonItems = rightBarButtonItems;
}
#pragma mark - 懒加载
-(ZMReallyNavigationBar *)navigationBar{
    if (_navigationBar == nil) {
        _navigationBar = [[ZMReallyNavigationBar alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height == 812 ? 20 : 0), [UIScreen mainScreen].bounds.size.width, 64)];
        _navigationBar.translucent = NO;
        [_navigationBar pushNavigationItem:self.navigationItem animated:YES];
    }
    return _navigationBar;
}

-(UINavigationItem *)navigationItem{
    if (_navigationItem == nil) {
        _navigationItem = [[UINavigationItem alloc] init];
    }
    return _navigationItem;
}
@end
