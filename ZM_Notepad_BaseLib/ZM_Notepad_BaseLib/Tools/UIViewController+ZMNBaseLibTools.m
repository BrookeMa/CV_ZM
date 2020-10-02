//
//  UIViewController+ZMNBaseLibTools.m
//  ZM_Notepad_BaseLib
//
//  Created by Chin on 2018/8/31.
//

#import "UIViewController+ZMNBaseLibTools.h"

#import "MMDrawerController.h"

@implementation UIViewController (ZMNBaseLibTools)

- (MMDrawerController *)drawerController
{
    UIViewController * parentViewController = self.parentViewController;
    while (parentViewController != nil) {
        if([parentViewController isKindOfClass:[MMDrawerController class]]){
            return (MMDrawerController *)parentViewController;
        }
        parentViewController = parentViewController.parentViewController;
    }
    return nil;
}

@end
