//
//  LotteryWinningModel.m
//  Lottery
//
//  Created by wangjingming on 2020/1/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryWinningModel.h"
#import "LotteryKindName.h"

@implementation LotteryWinningModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.identifier = @"";
        self.kindName = @"";
        self.icon = @"";
        self.issueNumber = @"";
        self.date = @"";
        self.sales = @"";
        self.jackpot = @"";
        self.radBall = @"";
        self.blueBall = @"";
        self.testNumber = @"";
        self.showPrizeView = NO;
        self.prizeArray = @[];
    }
    return self;
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [self init];
    if (self){
        self.identifier = [dict objectForKey:@"identifier"];
        self.kindName = [dict objectForKey:@"kindName"];
        self.icon = [dict objectForKey:@"icon"];
        self.issueNumber = [dict objectForKey:@"issueNumber"];
        self.date = [dict objectForKey:@"date"];
        self.sales = [dict objectForKey:@"sales"];
        self.jackpot = [dict objectForKey:@"jackpot"];
        self.radBall = [dict objectForKey:@"radBall"];
        self.blueBall = [dict objectForKey:@"blueBall"];
        self.testNumber = [dict objectForKey:@"testNumber"];
    }
    return self;
}

- (void)setIcon:(NSString *)icon{
    if ([icon isEqualToString:@""]){
        icon = [LotteryWinningModel identifierToString:self.identifier type:@"icon"];
    }
    _icon = icon;
}

#pragma mark - test
+ (NSString *)identifierToString:(NSString *)identifier type:(NSString *)type{
    if (kLotteryIsShuangseqiu(identifier)){
        if ([type isEqualToString:@"icon"]) return @"shuangseqiu";
        if ([type isEqualToString:@"name"]) return @"双色球";
    } else if (kLotteryIsDaletou(identifier)){
        if ([type isEqualToString:@"icon"]) return @"daletou";
        if ([type isEqualToString:@"name"]) return @"超级大乐透";
    } else if (kLotteryIsFucai3d(identifier)){
        if ([type isEqualToString:@"icon"]) return @"3d";
        if ([type isEqualToString:@"name"]) return @"福彩3D";
    } else if (kLotteryIsPailie3(identifier)){
        if ([type isEqualToString:@"icon"]) return @"pailie3";
        if ([type isEqualToString:@"name"]) return @"排列3";
    } else if (kLotteryIsPailie5(identifier)){
        if ([type isEqualToString:@"icon"]) return @"pailie5";
        if ([type isEqualToString:@"name"]) return @"排列5";
    } else if (kLotteryIsQixingcai(identifier)){
        if ([type isEqualToString:@"icon"]) return @"qixingcai";
        if ([type isEqualToString:@"name"]) return @"七星彩";
    } else if (kLotteryIsQilecai(identifier)){
        if ([type isEqualToString:@"icon"]) return @"qilecai";
        if ([type isEqualToString:@"name"]) return @"七乐彩";
    }
    return @"";
}

@end

@implementation LotteryPrizeModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.level = @"";
        self.number = @"";
        self.bonus = @"";
    }
    return self;
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [self init];
    if (self){
        
    }
    return self;
}
@end
