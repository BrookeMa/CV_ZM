//
//  ZMActionSheet.h
//  ZM_BaseLib
//
//  Created by Chin on 2018/9/8.
//

#import <UIKit/UIKit.h>

typedef void(^ZMActionSheetBlock)(NSInteger buttonIndex);

@interface ZMActionSheet : UIView

@property (nonatomic, copy) NSString * title;

+ (instancetype)actionWithTitle:(NSString *)title
              cancelButtonTitle:(NSString *)cancelButtonTitle
         destructiveButtonTitle:(NSString *)destructiveButtonTitle
              otherButtonTitles:(NSArray *)otherButtonTitles
               actionSheetBlock:(ZMActionSheetBlock) actionSheetBlock;

- (void)show;

@end
