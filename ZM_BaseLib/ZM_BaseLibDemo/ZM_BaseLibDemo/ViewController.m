//
//  ViewController.m
//  ZM_BaseLibDemo
//
//  Created by Chin on 2018/7/24.
//  Copyright © 2018年 ZMMobileTeam. All rights reserved.
//

#import "ViewController.h"
#import "ZMCommonMacros.h"

#import "ZMLocationManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationDidUpdate:)
                                                 name:kZMLocaltionMangerDidUpdateLocation
                                               object:nil];
    [[ZMLocationManager sharedInstance] startLocaltion];
}


- (void)locationDidUpdate:(NSNotification *)sender
{
    CLPlacemark * placeMark = sender.object;
    NSLog(@"%@",placeMark.locality);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
