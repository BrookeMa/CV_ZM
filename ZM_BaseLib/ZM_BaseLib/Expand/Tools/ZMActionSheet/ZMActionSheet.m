//
//  ZMActionSheet.m
//  ZM_BaseLib
//
//  Created by Chin on 2018/9/8.
//

#import "ZMActionSheet.h"

#define ZMScreenWidth   [UIScreen mainScreen].bounds.size.width
#define ZMScreenHeight  [UIScreen mainScreen].bounds.size.height
#define ZMRGB(r,g,b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define ZMTitleFont     [UIFont systemFontOfSize:18.0f]

#define ZMTitleHeight 60.0f
#define ZMButtonHeight  49.0f

#define ZMDarkShadowViewAlpha 0.35f

#define ZMShowAnimateDuration 0.3f
#define ZMHideAnimateDuration 0.2f

@interface ZMActionSheet()
{
    
    NSString * _cancelButtonTitle;
    NSString * _destructiveButtonTitle;
    NSArray  * _otherButtonTitles;
    
    
    UIView * _buttonBackgroundView;
    UIView * _darkShadowView;
}

@property (nonatomic, copy) ZMActionSheetBlock actionSheetBlock;

@end

@implementation ZMActionSheet

- (void)dealloc
{
    
}

+ (instancetype)actionWithTitle:(NSString *)title
              cancelButtonTitle:(NSString *)cancelButtonTitle
         destructiveButtonTitle:(NSString *)destructiveButtonTitle
              otherButtonTitles:(NSArray *)otherButtonTitles
               actionSheetBlock:(ZMActionSheetBlock) actionSheetBlock
{
    ZMActionSheet * sheet = [[ZMActionSheet alloc] initWithTitle:title
                                               cancelButtonTitle:cancelButtonTitle
                                          destructiveButtonTitle:destructiveButtonTitle
                                               otherButtonTitles:otherButtonTitles
                                                actionSheetBlock:actionSheetBlock];
    return sheet;
}

- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
             actionSheetBlock:(ZMActionSheetBlock) actionSheetBlock
{
    self = [super init];
    if(self) {
        _title = title;
        _cancelButtonTitle = cancelButtonTitle.length > 0 ? cancelButtonTitle : @"Cancel";
        _destructiveButtonTitle = destructiveButtonTitle;
        
        NSMutableArray *titleArray = [NSMutableArray array];
        if (_destructiveButtonTitle.length) {
            [titleArray addObject:_destructiveButtonTitle];
        }
        [titleArray addObjectsFromArray:otherButtonTitles];
        _otherButtonTitles = [NSArray arrayWithArray:titleArray];
        self.actionSheetBlock = actionSheetBlock;
        
        [self _initSubViews];
    }
    
    return self;
}


- (void)_initSubViews {
    
    self.frame = CGRectMake(0, 0, ZMScreenWidth, ZMScreenHeight);
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    
    _darkShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZMScreenWidth, ZMScreenHeight)];
    _darkShadowView.backgroundColor = ZMRGB(20, 20, 20);
    _darkShadowView.alpha = 0.0f;
    [self addSubview:_darkShadowView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismissView:)];
    [_darkShadowView addGestureRecognizer:tap];
    
    
    _buttonBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _buttonBackgroundView.backgroundColor = ZMRGB(220, 220, 220);
    [self addSubview:_buttonBackgroundView];
    
    if (self.title.length) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ZMButtonHeight-ZMTitleHeight, ZMScreenWidth, ZMTitleHeight)];
        titleLabel.text = _title;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = ZMRGB(125, 125, 125);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.backgroundColor = [UIColor whiteColor];
        [_buttonBackgroundView addSubview:titleLabel];
    }
    
    
    for (int i = 0; i < _otherButtonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:_otherButtonTitles[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = ZMTitleFont;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i==0 && _destructiveButtonTitle.length) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        UIImage *image = [UIImage imageNamed:@"actionSheetHighLighted.png"];
        [button setBackgroundImage:image forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(_didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonY = ZMButtonHeight * (i + (_title.length>0?1:0));
        button.frame = CGRectMake(0, buttonY, ZMScreenWidth, ZMButtonHeight);
        [_buttonBackgroundView addSubview:button];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = ZMRGB(210, 210, 210);
        line.frame = CGRectMake(0, buttonY, ZMScreenWidth, 0.5);
        [_buttonBackgroundView addSubview:line];
    }
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.tag = _otherButtonTitles.count;
    [cancelButton setTitle:_cancelButtonTitle forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = ZMTitleFont;
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"ACActionSheet.bundle/actionSheetHighLighted.png"];
    [cancelButton setBackgroundImage:image forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(_didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat buttonY = ZMButtonHeight * (_otherButtonTitles.count + (_title.length>0?1:0)) + 5;
    cancelButton.frame = CGRectMake(0, buttonY, ZMScreenWidth, ZMButtonHeight);
    [_buttonBackgroundView addSubview:cancelButton];
    
    CGFloat height = ZMButtonHeight * (_otherButtonTitles.count+1 + (_title.length>0?1:0)) + 5;
    _buttonBackgroundView.frame = CGRectMake(0, ZMScreenHeight, ZMScreenWidth, height);
    
}

- (void)_didClickButton:(UIButton *)button
{
    
    if (self.actionSheetBlock) {
        self.actionSheetBlock(button.tag);
    }
    
    [self _hide];
}

- (void)_dismissView:(UITapGestureRecognizer *)tap
{
    if (self.actionSheetBlock) {
        self.actionSheetBlock(_otherButtonTitles.count);
    }
    
    [self _hide];
}

- (void)show
{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    self.hidden = NO;
    
    [UIView animateWithDuration:ZMShowAnimateDuration animations:^{
        self->_darkShadowView.alpha = ZMDarkShadowViewAlpha;
        self->_buttonBackgroundView.transform = CGAffineTransformMakeTranslation(0, -self->_buttonBackgroundView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)_hide
{
    
    [UIView animateWithDuration:ZMHideAnimateDuration animations:^{
        self->_darkShadowView.alpha = 0;
        self->_buttonBackgroundView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
