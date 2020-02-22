//
//  LotteryPastPeriodViewController.m
//  Lottery
//  往期彩票
//  Created by wangjingming on 2020/1/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryPastPeriodViewController.h"

@interface LotteryPastPeriodViewController ()
@property (nonatomic, copy) NSString *identifier;
@end

@implementation LotteryPastPeriodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.identifier = [self.params objectForKey:@"identifier"];
    
    // Do any additional setup after loading the view.
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
