//
//  LotteryServiceViewController.m
//  Lottery
//
//  Created by wangjingming on 2019/12/26.
//  Copyright © 2019 wangjingming. All rights reserved.
//

#import "LotteryServiceViewController.h"
#import "LSVCLotteryWinningView.h"
#import "LotteryDownloadManager.h"

#import "Masonry.h"
#import "GlobalDefines.h"
#import "LotteryKindName.h"

#import "MJRefresh.h"

#import "UIView+Color.h"

@interface LotteryServiceViewController ()<LSVCLotteryWinningViewDelegate>
@property (nonatomic, strong) NSArray *identifiers;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSArray<LSVCLotteryWinningView *> *> *lotteryWinningDict;
@end

@implementation LotteryServiceViewController

- (NSString *)navBarLeftButtonImage{
    return @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarLeftButtonTitle:@"开奖服务"];
    [self initData];
    [self setUI];
}

- (void)initData{
    self.identifiers = @[
        kLotteryIdentifier_shuangseqiu,
        kLotteryIdentifier_daletou,
        kLotteryIdentifier_fucai3d,
        kLotteryIdentifier_pailie3,
        kLotteryIdentifier_pailie5,
        kLotteryIdentifier_qixingcai,
        kLotteryIdentifier_qilecai
    ];
    self.lotteryWinningDict = [@{} mutableCopy];
    for (NSString *ide in self.identifiers){
        self.lotteryWinningDict[ide] = @[];
    }
}

- (void)setUI{
    [self addRefreshHearderView:@selector(reloadNewData) otherScrollView:self.scrollView];
    [self.scrollView.mj_header beginRefreshing];
}

- (void)reloadNewData{
    NSInteger begin = 0, count = 1;
    WS(weakSelf);
    [LotteryDownloadManager lotteryDownload:begin count:count identifiers:self.identifiers finsh:^(NSDictionary<NSString *,NSArray *> * _Nonnull lotteryDict) {
        [weakSelf refreshLotterServiceView:lotteryDict];
    }];
}

- (void)refreshLotterServiceView:(NSDictionary <NSString *,NSArray *> *)lotteryDict {
    UIView *lastBackView;
    for (NSString *ide in self.identifiers){
        NSMutableArray *array = [self.lotteryWinningDict[ide] mutableCopy];
        if (array && array.count > 0 && array.count == lotteryDict[ide].count){
            for (int i = 0; i < array.count && i < lotteryDict[ide].count; i++){
                LSVCLotteryWinningView *view = array[i];
                view.model = lotteryDict[ide][i];
            }
        } else {
            [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [array removeAllObjects];
            
            UIView *backView = [[UIView alloc] init];
            [backView setShadowAndColor:kShadowColor];
            [self.scrollView addSubview:backView];
            
            LSVCLotteryWinningView *lastView;
            for (int i = 0; i < lotteryDict[ide].count; i++){
                LotteryWinningModel *model = lotteryDict[ide][i];
                LSVCLotteryWinningView *view = [[LSVCLotteryWinningView alloc] initWithStyle:LSVCLotteryWinningViewStyle_LotteryService];
                view.delegate = self;
                view.layer.cornerRadius = kCornerRadius;
                view.layer.masksToBounds = YES;
                view.model = model;
                [backView addSubview:view];
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (lastView){
                        make.top.mas_equalTo(lastView.mas_bottom);
                    } else {
                        make.top.mas_equalTo(0);
                    }
                    make.left.right.mas_equalTo(0);
                }];
                lastView = view;
            }
            if (lastView){
                [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                }];
            }
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kPadding15);
                make.width.mas_equalTo(self.view.mas_width).offset(-kPadding15*2);
                if (lastBackView){
                    make.top.mas_equalTo(lastBackView.mas_bottom).offset(kPadding15);
                } else {
                    make.top.mas_equalTo(kPadding15);
                }
            }];
            
            [backView setShadowAndColor:kShadowColor];
            lastBackView = backView;
        }
        self.lotteryWinningDict[ide] = array;
    }
    if (lastBackView){
        [self.view layoutIfNeeded];
        self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(lastBackView.frame) + 20);
    }
    [self.scrollView.mj_header endRefreshing];
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
