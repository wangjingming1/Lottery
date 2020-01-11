//
//  CalculatorViewController.m
//  Lottery
//
//  Created by wangjingming on 2020/1/3.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()

@end

@implementation CalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navBarLeftButtonTitle = @"算奖工具";
    // Do any additional setup after loading the view.
}

- (UIButton *)createNavBarLeftButton{
    UIButton *leftButton = [super createNavBarLeftButton];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -33, 0, -33)];
    return leftButton;
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
