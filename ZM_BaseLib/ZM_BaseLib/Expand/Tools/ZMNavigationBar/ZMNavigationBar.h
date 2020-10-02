//
//  ZMNavigationBar.h
//  NewInformationProject
//
//  Created by 毛立 on 2018/3/30.
//  Copyright © 2018年 上海展盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMNavigationBar : UIView
/**
 头部标题
 */
@property (nonatomic,copy) NSString *title;
/**
 头部标题view
 */
@property (nonatomic,strong) UIView *titleView;
/**
 左边标题View
 */
@property (nonatomic,strong) UIBarButtonItem *leftBarButtonItem;
/**
 右边标题
 */
@property (nonatomic,strong) UIBarButtonItem *rightBarButtonItem;
/**
 左边标题组
 */
@property(nullable,nonatomic,copy) NSArray<UIBarButtonItem *> *leftBarButtonItems;
/**
 右边标题组
 */
@property(nullable,nonatomic,copy) NSArray<UIBarButtonItem *> *rightBarButtonItems;
@end
