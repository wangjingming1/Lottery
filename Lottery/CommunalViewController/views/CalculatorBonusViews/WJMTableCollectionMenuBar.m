//
//  WJMTableCollectionMenuBar.m
//  Lottery
//
//  Created by wangjingming on 2020/3/8.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "WJMTableCollectionMenuBar.h"
#import "Masonry.h"
#import "GlobalDefines.h"

@interface WJMTableCollectionMenuBar()
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIView *menuBackView;
@end

@implementation WJMTableCollectionMenuBar
- (instancetype)initWithMenu:(NSString *)menu
{
    return [self initWithMenus:@[menu]];
}

- (instancetype)initWithMenus:(NSArray <NSString *> *)menus
{
    self = [self init];
    if (self) {
        [self setUI];
        [self createMenus:menus];
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.bottomLineView];
    [self addSubview:self.menuBackView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    [self.menuBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setSelectedMenu:(NSUInteger)index {
    WJMTableCollectionMenuView *otherView;
    for (WJMTableCollectionMenuView *view in self.menuBackView.subviews){
        view.selected = NO;
        if (index == view.index){
            view.selected = YES;
            otherView = view;
        }
    }
    [self selectMenuView:otherView];
}

- (void)createMenus:(NSArray <NSString *> *)menus {
    [self.menuBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < menus.count; i++){
        NSString *menu = menus[i];
        WJMTableCollectionMenuView *menuView = [self createMenuView:menu index:i];
        [self.menuBackView addSubview:menuView];
    }
    [self reloadLayout];
}

- (void)reloadLayout{
    if (self.menuBackView.subviews.count == 0) return;
    if (self.menuBackView.subviews.count == 1){
        [self.menuBackView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    } else {
        [self.menuBackView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [self.menuBackView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self).multipliedBy(1.0/self.menuBackView.subviews.count);
            make.height.mas_equalTo(self);
        }];
    }
}

- (UIView *)bottomLineView{
    if (!_bottomLineView){
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = kUIColorFromRGB10(200, 200, 200);
    }
    return _bottomLineView;
}

- (UIView *)menuBackView{
    if (!_menuBackView){
        _menuBackView = [[UIView alloc] init];
    }
    return _menuBackView;
}

- (WJMTableCollectionMenuView *)createMenuView:(NSString *)menu index:(NSUInteger)index{
    WJMTableCollectionMenuView *view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableCollectionMenuBar:menuViewWithIndex:)]){
        view = [self.delegate tableCollectionMenuBar:self menuViewWithIndex:index];
    } else {
        view = [[WJMTableCollectionMenuView alloc] initWithMenuName:menu];
    }
    view.menuNameLabel.text = menu;
    view.index = index;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuViewAction:)];
    tap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tap];
    return view;
}

- (void)menuViewAction:(UITapGestureRecognizer *)tap{
    WJMTableCollectionMenuView *otherView = (WJMTableCollectionMenuView *)tap.view;
    for (WJMTableCollectionMenuView *view in self.menuBackView.subviews){
        [view setSelected:otherView == view];
    }
    [self selectMenuView:otherView];
}

- (void)selectMenuView:(WJMTableCollectionMenuView *)menuView{
    if ([self.delegate respondsToSelector:@selector(tableCollectionMenuBar:selectTableCollectionMenuView:)]){
        [self.delegate tableCollectionMenuBar:self selectTableCollectionMenuView:menuView];
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

#pragma mark -
@interface WJMTableCollectionMenuView()
@property (nonatomic, strong) UIView *selectLineView;
@end

@implementation WJMTableCollectionMenuView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
        self.selected = NO;
    }
    return self;
}

- (instancetype)initWithMenuName:(NSString *)menuName;
{
    self = [self init];
    if (self) {
        self.menuNameLabel.text = menuName;
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.menuNameLabel];
    [self addSubview:self.selectLineView];
    [self.menuNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.selectLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.menuNameLabel);
        make.width.mas_equalTo(self.menuNameLabel.mas_width).multipliedBy(3/4.0);
        make.height.mas_equalTo(3);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.selectLineView.backgroundColor = selected ? [UIColor redColor] : [UIColor clearColor];
    self.menuNameLabel.textColor = selected ? kTintTextColor : kTitleTintTextColor;
}

- (UILabel *)menuNameLabel{
    if (!_menuNameLabel){
        _menuNameLabel = [[UILabel alloc] init];
        _menuNameLabel.textAlignment = NSTextAlignmentCenter;
        _menuNameLabel.textColor = kTintTextColor;
    }
    return _menuNameLabel;
}

- (UIView *)selectLineView{
    if (!_selectLineView){
        _selectLineView = [[UIView alloc] init];
        _selectLineView.backgroundColor = [UIColor clearColor];
    }
    return _selectLineView;
}
@end
