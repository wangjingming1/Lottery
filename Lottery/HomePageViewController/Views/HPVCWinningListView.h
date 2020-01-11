//
//  HPVCWinningListView.h
//  Lottery
//  首页的中奖彩种(双色球及大乐透)
//  Created by wangjingming on 2020/1/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HPVCWinningListViewDelegate <NSObject>
@optional
- (void)pushViewController:(Class)vcClass params:(NSDictionary *)params;
- (void)reloadViewFinish:(UIView *)initiator;
@end
@interface HPVCWinningListView : UIView
@property (nonatomic, weak) id <HPVCWinningListViewDelegate> delegate;

- (void)refreshView;
@end

NS_ASSUME_NONNULL_END