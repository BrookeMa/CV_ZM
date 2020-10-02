//
//  ZMNErrorViewController.m
//  Pods-ZM_Notepad_BaseLibDemo
//
//  Created by Chin on 2018/8/29.
//

#import "ZMNErrorViewController.h"
#import "Masonry.h"

@interface ZMNErrorViewController ()

@property (nonatomic, strong) UIImageView * imageView;

@end

@implementation ZMNErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"出错提示";
    
    [self setUpSubViews];
    [self addConstraints];

}

- (void)setUpSubViews
{
    
    [self.view addSubview:self.imageView];
}

- (void)addConstraints
{
    __weak typeof(self) weakSelf = self;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.view.mas_centerY);
        make.width.mas_equalTo((450/2.f));
        make.height.mas_equalTo((376/2.f));
    }];
}


- (UIImageView *)imageView
{
    if (_imageView == nil) {
        UIImage * img = [UIImage imageNamed:@"ZM_ErrorPage"];
        _imageView = [[UIImageView alloc] initWithImage:img];
    }
    return _imageView;
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
