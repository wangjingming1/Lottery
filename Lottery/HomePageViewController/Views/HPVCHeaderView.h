//
//  HPVCHeaderView.h
//  Lottery
//  头部轮播视图
//  Created by wangjingming on 2020/1/2.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LotteryBannerView;
NS_ASSUME_NONNULL_BEGIN

@interface HPVCHeaderView : UIView
@property (nonatomic, weak) LotteryBannerView *bannerView;
- (void)reloadBannerView;
@end

NS_ASSUME_NONNULL_END
