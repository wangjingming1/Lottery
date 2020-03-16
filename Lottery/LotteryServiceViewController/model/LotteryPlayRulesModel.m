//
//  LotteryPlayRulesModel.m
//  Lottery
//
//  Created by wangjingming on 2020/2/25.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryPlayRulesModel.h"

@implementation LotteryPlayRulesModel
+ (LotteryPlayRulesModel *)initLotteryPlayRulesModelWithDict:(NSDictionary *)dict{
    LotteryPlayRulesModel *model = [[LotteryPlayRulesModel alloc] init];
    model.kindName = [dict objectForKey:@"title"];
    model.sortOrder = [[dict objectForKey:@"sortOrder"] boolValue];
    model.lotteryShowTime = [dict objectForKey:@"lotteryTimeStr"];
    model.lotteryTime = [dict objectForKey:@"lotteryTime"];
    model.percentage = [dict objectForKey:@"percentage"];
    model.multipleBets = [dict objectForKey:@"multipleBets"];
    //----------------------------------------------------手动分割线
    NSArray <NSDictionary *> *prizeInfoArray = [dict objectForKey:@"lotteryPrize"];
    NSMutableArray <LotteryPrizeInfoModel *> *prizeInfoModelArray = [@[] mutableCopy];
    for (NSDictionary *prizeInfoDict in prizeInfoArray){
        LotteryPrizeInfoModel *prizeInfoModel = [LotteryPrizeInfoModel initLotteryPrizeInfoModelWithDict:prizeInfoDict];
        [prizeInfoModelArray addObject:prizeInfoModel];
    }
    model.prizeInfoArray = prizeInfoModelArray;

    //----------------------------------------------------手动分割线
    NSDictionary *radBullRules = [dict objectForKey:@"radBall"];
    model.radBullSame = [[radBullRules objectForKey:@"same"] boolValue];
    model.radBullCount = [[radBullRules objectForKey:@"count"] integerValue];
    model.radBullMultipleMaxCount = [[radBullRules objectForKey:@"multipleMaxCount"] integerValue];
    NSString *radBullRangeStr = [radBullRules objectForKey:@"scope"];
    NSArray *radBullRangeArray = [radBullRangeStr componentsSeparatedByString:@","];
    if (radBullRangeArray.count == 2){
        model.radBullRange = NSMakeRange([radBullRangeArray.firstObject integerValue], [radBullRangeArray.lastObject integerValue]);
    }
    
    //----------------------------------------------------手动分割线
    NSDictionary *blueBullRules = [dict objectForKey:@"blueBall"];
    model.blueBullSame = [[blueBullRules objectForKey:@"same"] boolValue];
    model.blueBullCount = [[blueBullRules objectForKey:@"count"] integerValue];
    model.blueBullMultipleMaxCount = [[blueBullRules objectForKey:@"multipleMaxCount"] integerValue];
    NSString *blueBullRangeStr = [blueBullRules objectForKey:@"scope"];
    NSArray *blueBullRangeArray = [blueBullRangeStr componentsSeparatedByString:@","];
    if (blueBullRangeArray.count == 2){
        model.blueBullRange = NSMakeRange([blueBullRangeArray.firstObject integerValue], [blueBullRangeArray.lastObject integerValue]);
    }
    
    return model;
}

@end


@implementation LotteryPrizeInfoModel
+ (LotteryPrizeInfoModel *)initLotteryPrizeInfoModelWithDict:(NSDictionary *)dict{
    LotteryPrizeInfoModel *model = [[LotteryPrizeInfoModel alloc] init];
    model.level = [dict objectForKey:@"level"];
    model.bonus = [dict objectForKey:@"bonus"];
    
    NSArray <NSDictionary *> *winningRulesArray = [dict objectForKey:@"winningRules"];
    NSMutableArray <LotteryWinningRulesModel *> *winningRulesModelArray = [@[] mutableCopy];
    for (NSDictionary *winningRulesDict in winningRulesArray){
        LotteryWinningRulesModel *winningRulesModel = [LotteryWinningRulesModel initLotteryWinningRulesModelWithDict:winningRulesDict];
        [winningRulesModelArray addObject:winningRulesModel];
    }
    model.winningRulesArray = winningRulesModelArray;
    
    NSDictionary *testbonusDict = [dict objectForKey:@"testbonus"];
    if (testbonusDict){
        LotteryTestBonus *textBonus = [LotteryTestBonus initLotteryTestBonusWithDict:testbonusDict];
        model.testBonus = textBonus;
    }
    return model;
}


@end


@implementation LotteryWinningRulesModel

+ (LotteryWinningRulesModel *)initLotteryWinningRulesModelWithDict:(NSDictionary *)dict{
    LotteryWinningRulesModel *model = [[LotteryWinningRulesModel alloc] init];
    model.radBullSameCount = [[dict objectForKey:@"rad"] integerValue];
    model.blueBullSameCount = [[dict objectForKey:@"blue"] integerValue];
    model.consistency = [[dict objectForKey:@"consistency"] boolValue];
    return model;
}

@end


@implementation LotteryTestBonus
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.percentage = @"";
        self.bonus = @"";
    }
    return self;
}

+ (LotteryTestBonus *)initLotteryTestBonusWithDict:(NSDictionary *)dict{
    LotteryTestBonus *model = [[LotteryTestBonus alloc] init];
    NSString *bonus = [dict objectForKey:@"bonus"];
    NSArray *array = [bonus componentsSeparatedByString:@","];
    if (array.count == 1){
        double number = [array.firstObject doubleValue];
        if (number < 1){
            model.percentage = array.firstObject;
        } else {
            model.bonus = array.firstObject;
        }
    } else if (array.count > 1){
        model.percentage = array.firstObject;
        model.bonus = array.lastObject;
    }
    NSString *lotteryNumberStr = [dict objectForKey:@"lotteryNumber"];
    NSArray *lotteryNumberArray = [lotteryNumberStr componentsSeparatedByString:@","];
    if (lotteryNumberArray.count == 2){
        model.lotteryNumberRange = NSMakeRange([lotteryNumberArray.firstObject integerValue], [lotteryNumberArray.lastObject integerValue]);
        
    }
    return model;
}

@end
