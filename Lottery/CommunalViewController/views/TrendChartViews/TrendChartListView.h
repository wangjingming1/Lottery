//
//  TrendChartListView.h
//  Lottery
//
//  Created by wangjingming on 2020/3/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MASViewAttribute;

@interface TrendChartListView : UIView
@property (nonatomic, copy) void (^selectIdentifier)(NSString *identifier);
- (void)setLotteryIdentifiers:(NSArray *)lotteryIdentifiers curIdentifier:(NSString *)curIdentifier;

- (void)setSafeAreaLayoutGuideBottom:(MASViewAttribute *)bottom;
@end

NS_ASSUME_NONNULL_END
