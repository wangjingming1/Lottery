//
//  HPVCWinningListView.m
//  Lottery
//
//  Created by wangjingming on 2020/1/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "HPVCWinningListView.h"
#import "GlobalDefines.h"
#import "Masonry.h"

#import "LotteryWinningModel.h"
#import "LSVCLotteryWinningView.h"

#import "LotteryDownloadManager.h"

@interface HPVCWinningListView()<LSVCLotteryWinningViewDelegate>
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSArray *modelArray;
@end

@implementation HPVCWinningListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)reloadWinningListView:(NSArray<LotteryWinningModel *> *)datas {
    [self setModelArray:datas];
    [self reloadView];
}

- (void)reloadView{
    [self.backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *lastView;
    for (LotteryWinningModel *model in self.modelArray){
        LSVCLotteryWinningView *view = [[LSVCLotteryWinningView alloc] initWithModel:model];
        [view.issueNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view.kindNameLabel.mas_right).offset(kPadding10);
            make.centerY.mas_equalTo(view.kindNameLabel);
        }];
        [view.kindNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-kPadding10);
        }];
        [view.jackpotLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view.kindNameLabel);
            make.right.mas_equalTo(view.jackpotLabel.superview).offset(-kPadding10);
        }];
        [view.rightArrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kPadding10);
            make.centerY.mas_equalTo(view.radBallView);
        }];
        view.delegate = self;
        [self.backView addSubview:view];
        if (lastView){
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = kUIColorFromRGB10(193, 194, 195);
            [self.backView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(kPadding15);
                make.right.mas_equalTo(-kPadding15);
                make.top.mas_equalTo(lastView.mas_bottom).mas_equalTo(kPadding10);
                make.height.mas_equalTo(1);
            }];
            
        }
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            if (lastView){
                make.top.mas_equalTo(lastView.mas_bottom).offset(kPadding10);
            } else {
                make.top.mas_equalTo(0);
            }
        }];
        lastView = view;
    }
    if (lastView){
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
    }
    
    if ([self.delegate respondsToSelector:@selector(reloadViewFinish:)]){
        [self.delegate reloadViewFinish:self];
    }
}

- (UIView *)backView{
    if (!_backView){
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = kCornerRadius;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

#pragma mark - LSVCLotteryWinningViewDelegate
- (void)pushViewController:(Class)vcClass params:(NSDictionary *)params {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushViewController:params:)]){
        [self.delegate pushViewController:vcClass params:params];
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
