//
//  ViewController.m
//  ZM_ThirdPartyLibraryExpandDemo
//
//  Created by Chin on 2018/8/1.
//  Copyright © 2018年 ZMMobileTeam. All rights reserved.
//

#import "ViewController.h"

#import "ZMRouterTools.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"测试1";
    
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"跳转" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    btn1.frame = CGRectMake(40, 100, 100, 44);
    
}

- (void)btn1Click:(id)sender
{
    NSLog(@"%s",__func__);
//    NSString * urlPath= @"zmtpled://push/T1ViewController?bgColor=0xFFF0F5&foo=bar";
//    NSString * urlPath= @"zmtpled://vc1/T1ViewController?bgColor=0xFFF0F5&foo=bar";
    NSString * urlPath= @"zmtpled://vc3/T2ViewController?bgColor=0xFFF0F5&foo=bar";
    NSURL * editPost  = [NSURL URLWithString:urlPath];
    
//     [[UIApplication sharedApplication] openURL:editPost];
    
    [self pushFormUrl:urlPath withParameters:@{@"zmKey":@"zmvalue",@"zmKey2":@"zmvalue2"}];
    
    
    
//    [self.navigationController pushViewController:[T1ViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
