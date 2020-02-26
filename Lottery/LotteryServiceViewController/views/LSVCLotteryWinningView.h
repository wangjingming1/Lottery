//
//  LSVCLotteryWinningView.h
//  Lottery
//  中奖视图
//  Created by wangjingming on 2020/1/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LotteryWinningModel;

@protocol LSVCLotteryWinningViewDelegate <NSObject>
@optional
- (void)pushViewController:(Class)vcClass params:(NSDictionary *)params;
@end


@interface LSVCLotteryWinningView : UIView
/**图标*/
@property (nonatomic, strong) UIImageView *iconView;
/**彩种名*/
@property (nonatomic, strong) UILabel *kindNameLabel;
/**期数*/
@property (nonatomic, strong) UILabel *issueNumberLabel;
/**时间*/
@property (nonatomic, strong) UILabel *dateLabel;
/**奖池*/
@property (nonatomic, strong) UILabel *jackpotLabel;
/**红球*/
@property (nonatomic, strong) UIView *radBallView;
/**篮球*/
@property (nonatomic, strong) UIView *blueBallView;
/**右侧箭头*/
@property (nonatomic, strong) UIImageView *rightArrowView;
/**试机号*/
@property (nonatomic, strong) UILabel *testNumberLabel;

/**数据model*/
@property (nonatomic, strong) LotteryWinningModel *model;
@property (nonatomic, weak) id<LSVCLotteryWinningViewDelegate> delegate;
- (instancetype)initWithModel:(LotteryWinningModel *)model;
@end

NS_ASSUME_NONNULL_END
