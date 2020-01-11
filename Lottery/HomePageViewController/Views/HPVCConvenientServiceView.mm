//
//  HPVCConvenientServiceView.m
//  Lottery
//
//  Created by wangjingming on 2020/1/3.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "HPVCConvenientServiceView.h"
#import "UIImageView+AddImage.h"
#import "UIView+Color.h"
#import <vector>
#import "Masonry.h"
#import "GlobalDefines.h"

#import "CalculatorViewController.h"
#import "LotteryStationViewController.h"
#import "TrendChartViewController.h"
#import "ImitationLotteryViewController.h"

/**便捷服务一行4个按钮*/
#define kLineCount 4

typedef NS_ENUM(NSInteger, ConvenientItemType){
    ConvenientItem_Calculator = 1100,
    ConvenientItem_LotteryStation,
    ConvenientItem_TrendChart,
    ConvenientItem_ImitationLottery,
    
    ConvenientItem_None,
};

@interface HPVCConvenientServiceView()
@property (nonatomic, strong) UIView *backView;
@end

@implementation HPVCConvenientServiceView
{
    std::vector<std::vector<NSInteger>> _subViewItemTypeVecs;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)refreshView{
    WS(weakSelf);
    [self reloadData:^{
        [weakSelf reloadView];
    }];
}

- (void)reloadData:(void(^)(void))finsh{
    _subViewItemTypeVecs.clear();
    
    NSInteger item = ConvenientItem_Calculator;
    std::vector<NSInteger> subViewItemTypeVec;
    while (item < ConvenientItem_None) {
        subViewItemTypeVec.push_back(item++);
        if (subViewItemTypeVec.size() == kLineCount){
            _subViewItemTypeVecs.push_back(subViewItemTypeVec);
            subViewItemTypeVec.clear();
        }
    }
//    _subViewItemTypeVecs.push_back({ConvenientItem_TrendChart, ConvenientItem_ImitationLottery});
    
    if (finsh) finsh();
}

- (void)reloadView{
    [self.backView.superview respondsToSelector:@selector(removeFromSuperview)];
    
    NSString *imageName = [self convenientItemTypeToString:ConvenientItem_None - 1 byType:@"imageName"];
    UIImage *iconImage = [UIImage imageNamed:imageName];
    
    CGFloat leadSpacing = 20, tailSpacing = 20;
    CGFloat itemPadding = 10;
    CGFloat labelHeight = 20;
    CGFloat itemLength = iconImage.size.height + labelHeight + itemPadding*2;
    UIView *lastView;
    NSMutableArray <NSArray *>*allItemTypeViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (std::vector<NSInteger> itemTypeVec : _subViewItemTypeVecs){
        NSMutableArray *itemTypeViewArray = [[NSMutableArray alloc] initWithCapacity:0];
        UIView *itemBackView = [[UIView alloc] init];
        [self.backView addSubview:itemBackView];
        [itemBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView){
                make.top.mas_equalTo(lastView.mas_bottom).offset(-itemPadding);
            } else {
                make.top.mas_equalTo(0);
            }
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(itemLength);
        }];
        for (NSInteger type : itemTypeVec){
            [itemTypeViewArray addObject:[self createConvenientItemView:type padding:itemPadding labelHeight:labelHeight parentView:itemBackView]];
        }
        if (itemTypeViewArray.count == kLineCount){
            [itemTypeViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:itemLength leadSpacing:leadSpacing tailSpacing:tailSpacing];
        } else if (itemTypeViewArray.count > 0 && allItemTypeViewArray.count > 0){
            for (int i = 0; i < itemTypeViewArray.count; i++){
                UIView *itemView = itemTypeViewArray[i];
                UIView *otherView = allItemTypeViewArray[0][i];
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(itemLength);
                    make.left.mas_equalTo(otherView.mas_left);
                    make.centerY.mas_equalTo(itemBackView);
                }];
            }
        }
        [allItemTypeViewArray addObject:itemTypeViewArray];
        lastView = itemBackView;
    }
    if (lastView){
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadViewFinish:)]){
        [self.delegate reloadViewFinish:self];
    }
}

- (UIView *)createConvenientItemView:(NSInteger)itemType padding:(CGFloat)padding labelHeight:(CGFloat)labelHeight parentView:(UIView *)parentView{
    UIView *view = [[UIView alloc] init];
    view.tag = itemType;
    [parentView addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
    }];
    NSString *imageName = [self convenientItemTypeToString:itemType byType:@"imageName"];
    [imageView setImageWithName:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *nameLab = [[UILabel alloc] init];
    [view addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(imageView.mas_bottom).offset(padding/2);
        make.height.mas_equalTo(labelHeight);
        make.bottom.mas_equalTo(-padding);
    }];
    NSString *name = [self convenientItemTypeToString:itemType byType:@"name"];
    nameLab.text = name;
    nameLab.numberOfLines = 1;
    nameLab.font = [UIFont systemFontOfSize:kSystemFontOfSize];
    nameLab.textColor = kUnselectedItemTintTextColor;
    nameLab.textAlignment = NSTextAlignmentCenter;
    //初始化一个点击手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAcyion:)];
    //把点击手势加上
    [view addGestureRecognizer:tap];
    
    return view;
}

- (NSString *)convenientItemTypeToString:(NSInteger)itemType byType:(NSString *)type{
    switch (itemType) {
        case ConvenientItem_Calculator:{
            if ([type isEqualToString:@"name"]){
                return @"算奖工具";
            } else if ([type isEqualToString:@"imageName"]){
                return @"calculator";
            } else if ([type isEqualToString:@"class"]){
                return NSStringFromClass([CalculatorViewController class]);// @"CalculatorViewController";
            }
            break;
        }
        case ConvenientItem_LotteryStation:{
            if ([type isEqualToString:@"name"]){
                return @"附近彩站";
            } else if ([type isEqualToString:@"imageName"]){
                return @"lotteryStation";
            } else if ([type isEqualToString:@"class"]){
                return NSStringFromClass([LotteryStationViewController class]);//@"LotteryStationViewController";
            }
            break;
        }
        case ConvenientItem_TrendChart:{
            if ([type isEqualToString:@"name"]){
                return @"走势图";
            } else if ([type isEqualToString:@"imageName"]){
                return @"trendChart";
            } else if ([type isEqualToString:@"class"]){
                return NSStringFromClass([TrendChartViewController class]);//@"TrendChartViewController";
            }
            break;
        }//62，132，247
        case ConvenientItem_ImitationLottery:{
            if ([type isEqualToString:@"name"]){
                return @"模拟购彩";
            } else if ([type isEqualToString:@"imageName"]){
                return @"imitationLottery";
            } else if ([type isEqualToString:@"class"]){
                return NSStringFromClass([ImitationLotteryViewController class]);//@"ImitationLotteryViewController";
            }
            break;
        }
        default:
            return @"";
    }
    return @"";
}

- (void)tapAcyion:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushViewController:params:)]){
        NSInteger tag = tap.view.tag;
        NSString *leftTitle = [self convenientItemTypeToString:tag byType:@"name"];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        params[@"leftTitle"] = leftTitle;
        
        NSString *vcClass = [self convenientItemTypeToString:tag byType:@"class"];
        [self.delegate pushViewController:NSClassFromString(vcClass) params:params];
    }
}

- (UIView *)backView{
    if (!_backView){
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = kCornerRadius;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
