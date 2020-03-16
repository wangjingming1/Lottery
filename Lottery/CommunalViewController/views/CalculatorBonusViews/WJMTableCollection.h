//
//  WJMTableCollection.h
//  Lottery
//  算奖工具顶部的菜单下的容器
//  Created by wangjingming on 2020/3/7.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "WJMTableCollectionMenuBar.h"

typedef NS_ENUM(NSInteger, WJMTableCollectionMenuBarPosition){
    WJMTableCollectionMenuBarPosition_Top,
    WJMTableCollectionMenuBarPosition_Bottom,
    WJMTableCollectionMenuBarPosition_Left,
    WJMTableCollectionMenuBarPosition_Right,
};
NS_ASSUME_NONNULL_BEGIN
@class WJMTableCollection;

@protocol WJMTableCollectionDelegate <NSObject>
@required

@optional
- (void)tableCollectionSelectIndex:(NSUInteger)index;
@end

@interface WJMTableCollection : UIView
@property (nonatomic) CGFloat menuBarHeight;  // default 30;
@property (nonatomic) WJMTableCollectionMenuBarPosition style; // default is WJMTableCollectionMenuBarPosition_Top.

@property (nonatomic, strong) WJMTableCollectionMenuBar *menuBar;
@property (nonatomic, strong) UIScrollView *containerView;

@property (nonatomic, weak) id<WJMTableCollectionDelegate> delegate;
- (void)setTableCollectionMenus:(NSArray <NSString *> *)menus;
@end

NS_ASSUME_NONNULL_END
