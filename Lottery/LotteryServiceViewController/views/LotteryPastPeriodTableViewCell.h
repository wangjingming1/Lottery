//
//  LotteryPastPeriodTableViewCell.h
//  Lottery
//
//  Created by wangjingming on 2020/2/28.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LotteryWinningModel;

@interface LotteryPastPeriodTableViewCell : UITableViewCell
@property (nonatomic, strong) LotteryWinningModel *model;
@end

NS_ASSUME_NONNULL_END
