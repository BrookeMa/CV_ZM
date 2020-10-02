//
//  T2ViewController.m
//  ZM_ThirdPartyLibraryExpandDemo
//
//  Created by Chin on 2018/8/3.
//  Copyright © 2018年 ZMMobileTeam. All rights reserved.
//

#import "T2ViewController.h"

#import "JLRRouteHandler.h"
#import "ZMRouterTools.h"


@interface T2ViewController () <JLRRouteHandlerTarget>

@end

@implementation T2ViewController

- (instancetype)initWithRouteParameters:(NSDictionary <NSString *, id> *)parameters
{
    self = [super init];
    self.routerInfo = [parameters copy]; // hold on to do something with later on
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"页面2 %@",self.routerInfo);
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
