//
//  TrendChartViewController.m
//  Lottery
//
//  Created by wangjingming on 2020/1/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "TrendChartViewController.h"
#import "LotteryKindName.h"
#import "LotteryKeyword.h"
#import "TrendChartListView.h"
#import "Masonry.h"
#import "GlobalDefines.h"
#import "WJMTableCollection.h"
#import "TrendChartSettingView.h"
#import "LotteryTrendChartSettingModel.h"

@interface TrendChartViewController ()<UIGestureRecognizerDelegate, WJMTableCollectionMenuBarDelegate>
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) NSArray *lotteryIdentifierArray;
@property (nonatomic, strong) LotteryKeyword *lotteryKeyword;

@property (nonatomic, strong) TrendChartListView *trendChartListView;
@property (nonatomic, strong) UIView *otherBackView;
@property (nonatomic, strong) WJMTableCollection *menuCollectionView;
@property (nonatomic, strong) TrendChartSettingView *settingView;
@property (nonatomic, strong) LotteryTrendChartSettingModel *settingModel;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSArray <LotterySettingModel *> *> *cacheSettingModel;
@end

@implementation TrendChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.identifier = [self.params objectForKey:@"identifier"];
    [self initData];
    
    [self setUI];
    [self reloadMenuController];
    [self reloadTrendChartView:self.identifier];
    // Do any additional setup after loading the view.
}

- (void)initData{
    self.lotteryIdentifierArray = @[
        kLotteryIdentifier_shuangseqiu,
        kLotteryIdentifier_daletou,
        kLotteryIdentifier_fucai3d,
        kLotteryIdentifier_pailie3,
        kLotteryIdentifier_pailie5,
        kLotteryIdentifier_qixingcai,
        kLotteryIdentifier_qilecai
    ];
    NSMutableDictionary *params = [self.params mutableCopy];
    if (!params) params = [@{@"identifier":kLotteryIdentifier_shuangseqiu} mutableCopy];
    if (![params objectForKey:@"identifier"]){
        self.identifier = self.lotteryIdentifierArray.firstObject;
        params[@"identifier"] = self.identifier;
    }
    if (![params objectForKey:@"leftTitle"]){
        params[@"leftTitle"] = [self.lotteryKeyword identifierToName:self.lotteryIdentifierArray.firstObject];
    }
    self.params = params;
    self.settingModel = [[LotteryTrendChartSettingModel alloc] initWithIdentifier:self.identifier];
    self.cacheSettingModel = [@{} mutableCopy];
}

- (void)setUI{
    [self reloadNavBar];
    self.menuCollectionView = [[WJMTableCollection alloc] init];
    self.menuCollectionView.delegate = self;
    self.menuCollectionView.menuBarHeight = 40;
    self.menuCollectionView.menuBarPadding = kPadding10;
    self.menuCollectionView.canMenuScroll = YES;
    self.menuCollectionView.menuBarStyle = MenuView_HighlightSelection;

    UILabel *tipsLab = [[UILabel alloc] init];
    tipsLab.text = kLocalizedString(@"开奖结果仅供参考，以官方开奖信息为准");
    tipsLab.textColor = kSubTipsTintTextColor;
    tipsLab.font = [UIFont systemFontOfSize:kSubTipsFontOfSize];
    
    [self.backgroundView addSubview:self.menuCollectionView];
    [self.menuCollectionView.containerView addSubview:tipsLab];
    
    [self.menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.backgroundView);
    }];
    
    [tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.menuCollectionView.containerView);
        make.bottom.mas_equalTo(self.menuCollectionView.containerView).offset(-kPadding20);
    }];
}

- (void)reloadNavBarLeftButton{
    NSString *kindName = [self.lotteryKeyword identifierToName:self.identifier];
    NSString *leftBtnStr = [NSString stringWithFormat:@"%@ ▼", kindName];
    NSMutableAttributedString *leftBtnAttributedStr = [[NSMutableAttributedString alloc] initWithString:leftBtnStr];
    NSRange range1 = [leftBtnStr rangeOfString:@"●"];
    NSRange range2 = [leftBtnStr rangeOfString:@"▼"];
    NSRange rangeAll = NSMakeRange(0, leftBtnStr.length);
    [leftBtnAttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8] range:range1];
    [leftBtnAttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:range2];
    
    [leftBtnAttributedStr addAttribute:NSBaselineOffsetAttributeName value:@(3) range:range1];
    [leftBtnAttributedStr addAttribute:NSBaselineOffsetAttributeName value:@(1) range:range2];
    [leftBtnAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rangeAll];
    
    [self.navBarLeftButton setAttributedTitle:leftBtnAttributedStr forState:UIControlStateNormal];
}

- (void)reloadNavBar{
    [self reloadNavBarLeftButton];
    
    UIButton *settingButton = [[UIButton alloc] init];
    [settingButton addTarget:self action:@selector(showSettingView:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
}

- (NSString *)getCurrentMenu{
    NSArray *titles = self.settingModel.titleArray;
    NSInteger index = [self.menuCollectionView.menuBar getSelectedMenuIndex];
    return titles[index];
}

- (NSArray <LotterySettingModel *> *)getCurrentSettingModelArray{
    NSString *title = [self getCurrentMenu];
    NSArray <LotterySettingModel *> *settingArray = self.cacheSettingModel[title];
    if (!settingArray || settingArray.count == 0){
        settingArray = [self.settingModel getParameterArray:title];
    }
    return settingArray;
}

- (void)showSettingView:(UIButton *)button{
    NSLog(@"showSettingView");
    [self.otherBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSString *title = [NSString stringWithFormat:@"%@%@",[self getCurrentMenu],kLocalizedString(@"设置")];
    self.settingView = [[TrendChartSettingView alloc] initWithTitle:title];
    
    NSArray <LotterySettingModel *> *settingArray = [self getCurrentSettingModelArray];
    [self.settingView setSettingArray:settingArray];
    [self.otherBackView addSubview:self.settingView];
    
    [self.settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.otherBackView);
        make.bottom.mas_equalTo(self.otherBackView);
    }];
    if (@available(iOS 11.0, *)) {
        [self.settingView setSafeAreaLayoutGuideBottom:self.view.mas_safeAreaLayoutGuideBottom];
    }
    
    WS(weakSelf);
    self.settingView.finishBlock = ^(){
        weakSelf.cacheSettingModel[title] = weakSelf.settingView.settingArray;
        [weakSelf removeOtherBackView];
    };
    self.settingView.cancelBlock = ^(){
        [weakSelf removeOtherBackView];
    };
}

- (void)reloadMenuController{
    NSArray *menus = self.settingModel.titleArray;
    [self.menuCollectionView setTableCollectionMenus:menus];
    //这里由于设置了view的Padding后,只有内容大小受改变才会重新去计算view的大小,而SelectedMenu会改变字体,所以这个方法调用需要在前面
    [self.menuCollectionView.menuBar reloadMenuBarToFull];
    if (kLotteryIsDaletou(self.identifier) || kLotteryIsShuangseqiu(self.identifier)){
        [self.menuCollectionView.menuBar setSelectedMenu:1];
    } else {
        [self.menuCollectionView.menuBar setSelectedMenu:0];
    }
}

- (void)navBarLeftButtonClick:(UIButton *)leftButton{
    [self removeOtherBackView];
    [self.otherBackView addSubview:self.trendChartListView];
    [self.trendChartListView setLotteryIdentifiers:self.lotteryIdentifierArray curIdentifier:self.identifier];
    
    WS(weakSelf);
    [self.trendChartListView setSelectIdentifier:^(NSString * _Nonnull identifier) {
        [weakSelf reloadTrendChartView:identifier];
    }];
    
    [self.trendChartListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    if (@available(iOS 11.0, *)) {
        [self.trendChartListView setSafeAreaLayoutGuideBottom:self.view.mas_safeAreaLayoutGuideBottom];
    }
}

- (void)reloadTrendChartView:(NSString *)identifier{
    self.identifier = identifier;
    self.settingModel.identifier = identifier;
    [self reloadMenuController];
    
    [self reloadNavBarLeftButton];
    [self removeOtherBackView];
}

- (LotteryKeyword *)lotteryKeyword{
    if (!_lotteryKeyword){
        _lotteryKeyword = [[LotteryKeyword alloc] init];
    }
    return _lotteryKeyword;
}

- (TrendChartListView *)trendChartListView{
    if (!_trendChartListView){
        _trendChartListView = [[TrendChartListView alloc] init];
        _trendChartListView.backgroundColor = [UIColor whiteColor];
    }
    return _trendChartListView;
}

- (UIView *)otherBackView{
    if (!_otherBackView){
        _otherBackView = [[UIView alloc] init];
        _otherBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOtherBackView:)];
        tap.cancelsTouchesInView = NO;
        tap.delegate = self;
        [_otherBackView addGestureRecognizer:tap];
        
        [self.view addSubview:_otherBackView];
        [_otherBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _otherBackView;
}

- (void)tapOtherBackView:(UITapGestureRecognizer *)tap{
    [self removeOtherBackView];
}

- (void)removeOtherBackView{
    [_otherBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_otherBackView removeFromSuperview];
    _otherBackView = nil;
    
    _trendChartListView = nil;
}

kImportantReminder(@"由于TableViewCell的点击事件被父视图otherBackView捕获,所以这里做了判断")
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    获取点击视图的类型
    UIView *touchView = touch.view;
    
//    NSString * touchClass = NSStringFromClass([touch.view class]);
////    判断点击视图的类型是不是UITableView的cell类型
//    if ([touchClass isEqualToString:@"UITableViewCellContentView"]) {
////        如果是，返回false
//        return false;
//    }else{
////        如果不是返回true
//        return true;
//    }
    return touchView == _otherBackView;
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
