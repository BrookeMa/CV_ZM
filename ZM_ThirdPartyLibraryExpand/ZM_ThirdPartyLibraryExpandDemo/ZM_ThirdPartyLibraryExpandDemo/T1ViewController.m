//
//  T1ViewController.m
//  ZM_ThirdPartyLibraryExpandDemo
//
//  Created by Chin on 2018/8/1.
//  Copyright © 2018年 ZMMobileTeam. All rights reserved.
//

#import "T1ViewController.h"

#import "JLRRouteHandler.h"
#import <ZMRouterTools.h>

@interface T1ViewController () <JLRRouteHandlerTarget>

@end

@implementation T1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"路由跳转测试1";
    
    self.view.backgroundColor = [UIColor blueColor];
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"跳转" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    btn1.frame = CGRectMake(40, 100, 100, 44);

    
}

- (void)btn1Click:(id)sender
{
    NSLog(@"%s",__func__);
}


- (instancetype)initWithRouteParameters:(NSDictionary <NSString *, id> *)parameters
{
    self = [super init];
    self.routerInfo = [parameters copy]; // hold on to do something with later on
    return self;
}

#pragma mark - JLRRouteHandlerTarget -
- (BOOL)handleRouteWithParameters:(NSDictionary<NSString *, id> *)parameters
{
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
