//
//  WJMTableCollection.m
//  Lottery
//
//  Created by wangjingming on 2020/3/7.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "WJMTableCollection.h"
#import "Masonry.h"

@interface WJMTableCollection()<WJMTableCollectionMenuBarDelegate>

@end

@implementation WJMTableCollection

- (instancetype)init{
    self = [super init];
    if (self){
        self.menuBarHeight = 30;
    }
    return self;
}

- (void)setTableCollectionMenus:(NSArray <NSString *> *)menus {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.menuBar = [[WJMTableCollectionMenuBar alloc] initWithMenus:menus];
    self.menuBar.delegate = self;
    [self addSubview:self.containerView];
    [self addSubview:self.menuBar];
    
    [self.menuBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(self.menuBarHeight);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.menuBar.mas_bottom);
        make.width.mas_equalTo(self.mas_width);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setMenuBarHeight:(CGFloat)menuBarHeight{
    _menuBarHeight = menuBarHeight;
    [self.menuBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(menuBarHeight);
    }];
}

- (UIScrollView *)containerView{
    if (!_containerView){
        _containerView = [[UIScrollView alloc] init];
    }
    return _containerView;
}

#pragma mark - WJMTableCollectionMenuBarDelegate
- (void)tableCollectionMenuBar:(WJMTableCollectionMenuBar *)tableCollectionMenuBar selectTableCollectionMenuView:(WJMTableCollectionMenuView *)selectTableCollectionMenuView{
    if ([self.delegate respondsToSelector:@selector(tableCollectionSelectIndex:)]){
        [self.delegate tableCollectionSelectIndex:selectTableCollectionMenuView.index];
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
