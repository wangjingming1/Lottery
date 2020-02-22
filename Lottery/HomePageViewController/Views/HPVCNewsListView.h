//
//  HPVCNewsListView.h
//  Lottery
//
//  Created by wangjingming on 2020/1/8.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LottoryNewsModel;
NS_ASSUME_NONNULL_BEGIN
@protocol HPVCNewListViewDelegate <NSObject>
@optional
- (void)pushViewController:(Class)vcClass params:(NSDictionary *)params;
- (void)reloadViewFinish:(UIView *)initiator;
@end
@interface HPVCNewsListView : UIView
@property (nonatomic, weak) id <HPVCNewListViewDelegate> delegate;

- (void)reloadNewListView:(NSArray<LottoryNewsModel *> *)datas;
@end

NS_ASSUME_NONNULL_END
