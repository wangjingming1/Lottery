//
//  WJMTableCollectionMenuBar.h
//  Lottery
//  算奖工具顶部的菜单选项卡(双色球、大乐透)
//  Created by wangjingming on 2020/3/8.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WJMTableCollectionMenuBar;
@class WJMTableCollectionMenuView;

@protocol WJMTableCollectionMenuBarDelegate <NSObject>

@optional 
- (WJMTableCollectionMenuView *)tableCollectionMenuBar:(WJMTableCollectionMenuBar *)tableCollectionMenuBar menuViewWithIndex:(NSUInteger)index;

- (void)tableCollectionMenuBar:(WJMTableCollectionMenuBar *)tableCollectionMenuBar selectTableCollectionMenuView:(WJMTableCollectionMenuView *)selectTableCollectionMenuView;

@end

@interface WJMTableCollectionMenuBar : UIView
@property (nonatomic, weak) id<WJMTableCollectionMenuBarDelegate> delegate;

- (instancetype)initWithMenu:(NSString *)menu;
- (instancetype)initWithMenus:(NSArray <NSString *> *)menus;

- (void)setSelectedMenu:(NSUInteger)index;
@end


@interface WJMTableCollectionMenuView : UIView
@property (nonatomic) NSUInteger index;
@property (nonatomic, strong) UILabel *menuNameLabel;
@property (nonatomic) BOOL selected;
- (instancetype)initWithMenuName:(NSString *)menuName;
- (void)setSelected:(BOOL)selected;
@end
NS_ASSUME_NONNULL_END
