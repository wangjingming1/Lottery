//
//  BaseUIViewController.m
//  Lottery
//
//  Created by wangjingming on 2019/12/26.
//  Copyright © 2019 wangjingming. All rights reserved.
//

#import "BaseUIViewController.h"
#import "BaseCollectionViewCell.h"
#import "GlobalDefines.h"
#import "Masonry.h"
#import "UIViewController+Cloudox.h"
#import "UINavigationController+Cloudox.h"

#define kBackgroundColor    kUIColorFromRGB10(250, 250, 250)

@interface BaseUIViewController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@end

@implementation BaseUIViewController

- (CGFloat)getStatusbarHeight{
    //状态栏高度
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

- (CGFloat)getNavigationbarHeight{
    //导航栏高度+状态栏高度
    CGFloat statusBarH = [self getStatusbarHeight];
    return self.navigationController.navigationBar.frame.size.height + statusBarH;
}

- (CGFloat)getTabbarHeight{
    //Tabbar高度
    return self.tabBarController.tabBar.bounds.size.height;
}

- (CGFloat)getCurrentAlpha{
    return [self.navBarBgAlpha floatValue];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if (self.params && [self.params objectForKey:@"leftTitle"]){
        self.navBarLeftButtonTitle = self.params[@"leftTitle"];
    }
    self.view.backgroundColor = kBackgroundColor;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)setNavBarLeftButtonTitle:(NSString *)navBarLeftButtonTitle {
    _navBarLeftButtonTitle = navBarLeftButtonTitle;
    UIButton *leftButton = [self createNavBarLeftButton];
    [leftButton setTitle:self.navBarLeftButtonTitle forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)setNavBarLeftButtonAttributedTitle:(NSAttributedString *)navBarLeftButtonAttributedTitle{
    _navBarLeftButtonAttributedTitle = navBarLeftButtonAttributedTitle;
    UIButton *leftButton = [self createNavBarLeftButton];
    [leftButton setAttributedTitle:navBarLeftButtonAttributedTitle forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (NSString *)navBarLeftButtonImage{
    return @"leftWhiteArrow";
}

- (UIButton *)createNavBarLeftButton{
    UIButton *leftButton = [[UIButton alloc] init];
    [leftButton setImage:[UIImage imageNamed:[self navBarLeftButtonImage]] forState:UIControlStateNormal];
    
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -33, 0, -33)];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(navBarLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return leftButton;
}

- (void)navBarLeftButtonClick:(UIButton *)leftButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushViewController:(Class)vcClass params:(NSDictionary *)params{
    NSLog(@"className:%@", vcClass);
    UIViewController *vc = [[vcClass alloc] init];
    if ([vc isKindOfClass:[BaseUIViewController class]]){
        ((BaseUIViewController *)vc).params = params;
    }
    //隐藏底部tabbar
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)backgroundView{
    if (!_backgroundView) {
        CGFloat navigationbarHeight = [self getNavigationbarHeight];
        CGFloat tabbarH = [self getTabbarHeight];
        
        _backgroundView = [[UIView alloc] init];
        [self.view addSubview:_backgroundView];
        
        [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(navigationbarHeight);
            make.bottom.mas_equalTo(-tabbarH);
        }];
    }
    return _backgroundView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_scrollView];
        //设置scrollViewd内容不由系统自动调整(子视图不考虑导航栏跟状态栏，直接到顶)
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        CGFloat tabbarH = [self getTabbarHeight];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-tabbarH);
        }];
    }
    return _scrollView;
}

@end
