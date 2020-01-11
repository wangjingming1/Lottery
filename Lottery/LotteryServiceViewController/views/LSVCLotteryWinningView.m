//
//  LSVCLotteryWinningView.m
//  Lottery
//
//  Created by wangjingming on 2020/1/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LSVCLotteryWinningView.h"
#import "LottoryWinningModel.h"
#import "GlobalDefines.h"
#import "Masonry.h"
#import "UIImageView+AddImage.h"

#import "LotteryPastPeriodViewController.h"

/**彩票种类字号*/
#define kLotteryWinningViewKindNameLabelSize    17
/**期数时间及奖池字号*/
#define kLotteryWinningViewLotteryInfoLabelSize 10
/**红蓝球字号*/
#define kLotteryWinningViewBallLabelSize        15

@interface LSVCLotteryWinningView()
/**中奖信息底视图*/
@property (nonatomic, strong) UIView *backView;
/**彩种及时间奖池等信息*/
@property (nonatomic, strong) UIView *lotteryInfoView;
/**走势图*/
@property (nonatomic, strong) UIView *trendChartView;
/**红蓝球中间的线*/
@property (nonatomic, strong) UIView *lineView;

@end

@implementation LSVCLotteryWinningView
- (instancetype)initWithModel:(LottoryWinningModel *)model
{
    self = [super init];
    if (self) {
        [self setUI];
        self.model = model;
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.backView];
    [self addSubview:self.trendChartView];
    //初始化一个点击手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAcyion:)];
    //把点击手势加上
    [self.backView addGestureRecognizer:tap];
    
    [self.backView addSubview:self.iconView];
    [self.backView addSubview:self.lotteryInfoView];
    
    [self.lotteryInfoView addSubview:self.kindNameLabel];
    [self.lotteryInfoView addSubview:self.issueNumberLabel];
    [self.lotteryInfoView addSubview:self.dateLabel];
    [self.lotteryInfoView addSubview:self.jackpotLabel];
    
    [self.backView addSubview:self.radBallView];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.blueBallView];
    [self.backView addSubview:self.testNumberLabel];
    [self.backView addSubview:self.rightArrowView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
    }];
    [self.lotteryInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(kPadding10);
        make.right.mas_equalTo(-kPadding10);//(self.rightArrowView.mas_left).offset
        make.centerY.mas_equalTo(self.iconView);
    }];
    [self.trendChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.backView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kPadding10);
        make.top.mas_equalTo(kPadding10);
    }];
    [self.kindNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(kPadding10);
    }];
    [self.issueNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.kindNameLabel);
        make.top.mas_equalTo(self.kindNameLabel.mas_bottom).offset(kPadding10);
        make.bottom.mas_equalTo(-kPadding10);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.issueNumberLabel.mas_right).offset(kPadding10);
        make.centerY.mas_equalTo(self.issueNumberLabel);
    }];
    [self.jackpotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateLabel.mas_right).offset(kPadding10);
        make.centerY.mas_equalTo(self.dateLabel);
    }];
    [self.radBallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView);
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(kPadding10);
        make.bottom.mas_equalTo(-kPadding10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.radBallView.mas_right).offset(kPadding10);
        make.centerY.mas_equalTo(self.radBallView);
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(15);
    }];
    [self.blueBallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineView.mas_right).offset(kPadding10);
        make.centerY.mas_equalTo(self.lineView);
    }];
    [self.rightArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kPadding10);
        make.centerY.mas_equalTo(self.backView);
    }];
}

- (void)setModel:(LottoryWinningModel *)model{
    _model = model;
    [self.iconView setImageWithName:self.model.icon];
    self.kindNameLabel.text = self.model.kindName;
    self.issueNumberLabel.text = self.model.issueNumber;
    self.dateLabel.text = self.model.date;
    self.jackpotLabel.text = [NSString stringWithFormat:@"奖池 %@亿", self.model.jackpot];
    
    [self reloadBallView:self.radBallView ballColor:@"radBall" ballStr:self.model.radBall];
    [self reloadBallView:self.blueBallView ballColor:@"blueBall" ballStr:self.model.blueBall];
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        if ([self.model.blueBall isEqualToString:@""]){
            make.width.mas_equalTo(0);
        } else {
            make.width.mas_equalTo(1);
        }
    }];
}

- (void)reloadBallView:(UIView *)ballView ballColor:(NSString *)ballColor ballStr:(NSString *)ballStr{
    [ballView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *radBallArray = [ballStr componentsSeparatedByString:@","];
    if (radBallArray.count){
        UIView *lastView;
        for (NSString *radBall in radBallArray){
            UIImageView *imageView = [[UIImageView alloc] init];
            [ballView addSubview:imageView];
            [imageView setImageWithName:ballColor];
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:kLotteryWinningViewBallLabelSize];
            label.textColor = [UIColor whiteColor];
            [imageView addSubview:label];
            label.text = radBall;
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (lastView){
                    make.left.mas_equalTo(lastView.mas_right).offset(kPadding10);
                } else {
                    make.left.mas_equalTo(0);
                }
                make.top.bottom.mas_equalTo(0);
            }];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(imageView);
            }];
            lastView = imageView;
        }
        if (lastView){
            [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
            }];
        }
    }
}

- (UIView *)backView{
    if (!_backView){
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIView *)lotteryInfoView{
    if (!_lotteryInfoView){
        _lotteryInfoView = [[UIView alloc] init];
    }
    return _lotteryInfoView;
}

- (UIView *)trendChartView{
    if (!_trendChartView){
        _trendChartView = [[UIView alloc] init];
    }
    return _trendChartView;
}

- (UIImageView *)iconView{
    if (!_iconView){
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UILabel *)kindNameLabel{
    if (!_kindNameLabel){
        _kindNameLabel = [[UILabel alloc] init];
        _kindNameLabel.numberOfLines = 1;
        _kindNameLabel.textColor = kTitleTintTextColor;
        _kindNameLabel.font = [UIFont boldSystemFontOfSize:kLotteryWinningViewKindNameLabelSize];
    }
    return _kindNameLabel;
}

- (UILabel *)issueNumberLabel{
    if (!_issueNumberLabel){
        _issueNumberLabel = [[UILabel alloc] init];
        _issueNumberLabel.numberOfLines = 1;
        _issueNumberLabel.textColor = kSubtitleTintTextColor;
        _issueNumberLabel.font = [UIFont systemFontOfSize:kLotteryWinningViewLotteryInfoLabelSize];
    }
    return _issueNumberLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel){
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.numberOfLines = 1;
        _dateLabel.textColor = kUIColorFromRGB10(165, 166, 167);
        _dateLabel.font = [UIFont systemFontOfSize:kLotteryWinningViewLotteryInfoLabelSize];
    }
    return _dateLabel;
}

- (UILabel *)jackpotLabel{
    if (!_jackpotLabel){
        _jackpotLabel = [[UILabel alloc] init];
        _jackpotLabel.numberOfLines = 1;
        _jackpotLabel.textColor = [UIColor redColor];
        _jackpotLabel.font = [UIFont systemFontOfSize:kLotteryWinningViewLotteryInfoLabelSize];
    }
    return _jackpotLabel;
}

- (UIView *)radBallView{
    if (!_radBallView){
        _radBallView = [[UIView alloc] init];
    }
    return _radBallView;
}

- (UIView *)lineView{
    if (!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kUIColorFromRGB10(193, 194, 195);
    }
    return _lineView;
}

- (UIView *)blueBallView{
    if (!_blueBallView){
        _blueBallView = [[UIView alloc] init];
    }
    return _blueBallView;
}

- (UIImageView *)rightArrowView{
    if (!_rightArrowView){
        _rightArrowView = [[UIImageView alloc] init];
        [_rightArrowView setImageWithName:@"rightArrow"];
    }
    return _rightArrowView;
}


#pragma mark - LSVCLotteryWinningViewDelegate
- (void)tapAcyion:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushViewController:params:)]){
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        params[@"leftTitle"] = self.model.kindName;
        params[@"identifier"] = self.model.identifier;
        [self.delegate pushViewController:[LotteryPastPeriodViewController class] params:params];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
