//
//  LotteryDownloadManager.m
//  Lottery
//
//  Created by wangjingming on 2020/1/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryDownloadManager.h"
#import "LotteryKindName.h"

#import "HttpManager.h"

#import "LotteryWinningModel.h"
#import "LotteryPlayRulesModel.h"
#import "LotteryPracticalMethod.h"

@implementation LotteryDownloadManager

+ (void)lotteryDownload:(NSInteger)begin count:(NSInteger)count identifiers:(NSArray *)identifiers finsh:(void (^)(NSArray *lotterys))finsh {
#ifdef kTEST
    NSMutableArray *lotterys = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *ide in identifiers){
        NSArray *array = [LotteryDownloadManager lotteryWinningModelRandomizedByIdentifier:ide begin:begin count:count];
        [lotterys addObjectsFromArray:array];
    }
    if (finsh){
        finsh(lotterys);
    }
#else
    NSString *url = @"";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    params[@"begin"] = [NSString stringWithFormat:@"%ld", begin];
    params[@"count"] = [NSString stringWithFormat:@"%ld", count];
    NSString *ides = @"";
    for (int i = 0; i < identifiers.count; i++){
        [ides stringByAppendingString:identifiers[i]];
        if (i <= identifiers.count - 1){
            [ides stringByAppendingString:@","];
        }
    }
    params[@"identifiers"] = ides;
    [HttpManager http:url params:params finsh:^(id  _Nonnull responseObject) {
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        LotteryWinningModel *model = [[LotteryWinningModel alloc] initWithDict:dic];
        [array addObject:model];
    }];
#endif
}
#pragma mark - test newRandomized
+ (NSArray <LotteryWinningModel *> *)lotteryWinningModelRandomizedByIdentifier:(NSString *)identifier begin:(NSInteger)begin count:(NSInteger)count{
    
    NSMutableArray <LotteryWinningModel *>*winningModelArray = [@[] mutableCopy];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"playRules" ofType:@"json"];
    
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *jsonData = [readHandle readDataToEndOfFile];
    
    NSError *err;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    NSDictionary *dict = [jsonDict objectForKey:@"data"];
    NSDictionary *playRulesDict = [dict objectForKey:identifier];
    
    if (playRulesDict) {
        LotteryPlayRulesModel *playRulesModel = [LotteryPlayRulesModel initLotteryPlayRulesModelWithDict:playRulesDict];
        playRulesModel.identifier = identifier;
        
        NSArray *dateArray = [LotteryDownloadManager getLotteryTimeArrayByPlayRulesModel:playRulesModel begin:begin count:count];
        NSString *icon = [LotteryWinningModel identifierToString:identifier type:@"icon"];
        NSString *name = [LotteryWinningModel identifierToString:identifier type:@"name"];
        for (NSInteger i = 0; i < dateArray.count; i++){
            LotteryWinningModel *model = [[LotteryWinningModel alloc] init];
            model.identifier = identifier;
            model.icon = icon;
            model.kindName = name;
            model.issueNumber = [LotteryDownloadManager getIssueNumber:i];
            model.date = dateArray[i];
            model.testNumber = [LotteryDownloadManager getTestNumber:identifier];
            //设置中奖号码
            [LotteryDownloadManager setLotteryWinningModelSalesAndBall:model playRulesModel:playRulesModel];
            //设置奖级信息
            [LotteryDownloadManager setLotteryWinningModelPrize:model playRulesModel:playRulesModel];
            [winningModelArray addObject:model];
        }
    }
    return winningModelArray;
}

+ (NSArray <NSString *> *)getLotteryTimeArrayByPlayRulesModel:(LotteryPlayRulesModel *)model begin:(NSInteger)begin count:(NSInteger)count{
    NSString *lotteryTimeStr = model.lotteryTime;
    NSArray *otherArray = [lotteryTimeStr componentsSeparatedByString:@","];
    if (otherArray.count < 2) return @[];
    //时间
    NSString *lotteryTime = otherArray.lastObject;
    //星期几
    NSArray *weekday = [otherArray subarrayWithRange:NSMakeRange(0, otherArray.count - 1)];
    NSMutableArray *weekdayArray = [@[] mutableCopy];
    NSArray *allWeekdayArray = [LotteryPracticalMethod getWeekdayArray];
    for (NSString *str in weekday){
        //转成数组下标，不能从1开始，需要-1
        NSInteger weekdayIndex = [str integerValue] - 1;
        //我们这里的星期列表是从周日开始的，所以还需要将下标转成我们的列表下标
        weekdayIndex = (weekdayIndex + 1)%allWeekdayArray.count;
        [weekdayArray addObject:allWeekdayArray[weekdayIndex]];
    }
    NSDate *currentDate = [NSDate date];
    NSMutableArray *dateArray = [@[] mutableCopy];
    //从今天开始往前推dayCount天
    NSInteger i = 0;
    //符合开奖日期的时间数量
    NSInteger dayCount = 0;
    while (1) {
        NSTimeInterval days = -(24 * 60 * 60 * i);  // 一天一共有多少秒
        //往前推i天的时间
        NSDate *appointDate = [currentDate dateByAddingTimeInterval:days];
        NSString *weekdata = [LotteryPracticalMethod weekdayStringWithDate:appointDate];
        //判断是否是开奖日期(如大乐透是每周一、三、六 20:30开奖)
        if ([weekdayArray indexOfObject:weekdata] != NSNotFound){
            if (dayCount >= begin){
                if (i == 0 && begin == 0){
                    //如果今天恰好是开奖日期，判断是否到了开奖时间
                    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"HH:mm"];
                    NSString *dateTime = [formatter stringFromDate:currentDate];
                    NSDate *timeDate = [formatter dateFromString:dateTime];
                    NSDate *lotteryTimeDate = [formatter dateFromString:lotteryTime];
                    NSComparisonResult result = [timeDate compare:lotteryTimeDate];
                    if (result == NSOrderedSame || result == NSOrderedAscending){
                        continue;
                    }
                }
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy.MM.dd"];
                //获取当前时间日期展示字符串 如：05.23
                NSString *appointDateStr = [formatter stringFromDate:appointDate];
                [dateArray addObject:appointDateStr];
                if (dateArray.count == count) {
                    break;
                }
            }
            dayCount++;
        }
        i++;
    }
    return dateArray;
}

+ (void)setLotteryWinningModelSalesAndBall:(LotteryWinningModel *)model playRulesModel:(LotteryPlayRulesModel *)playRulesModel {
    NSString *identifier = model.identifier;
    long long sales = 0;
    long long jackpot = 0;
    if (kLotteryIsShuangseqiu(identifier)){
        sales = 300000000 + arc4random_uniform(200000000);//3亿，2亿
        jackpot = sales + 100000000 + arc4random_uniform(500000000);//1亿，5亿
    } else if (kLotteryIsDaletou(identifier)){
        sales = 100000000 + arc4random_uniform(300000000);//1亿，4亿
        jackpot = sales + 100000000 + arc4random_uniform(1000000000);//1亿，10亿
    } else if (kLotteryIsFucai3d(identifier)){
        sales = 50000000 + arc4random_uniform(1000000);//5千万，1百万
        model.testNumber = [LotteryDownloadManager getTestNumber:identifier];
    } else if (kLotteryIsPailie3(identifier)){
        sales = 10000000 + arc4random_uniform(30000000);//1千万，3千万
    } else if (kLotteryIsPailie5(identifier)){
        sales = 10000000 + arc4random_uniform(6000000);//1千万，6百万
        jackpot = 300000000 + arc4random_uniform(100000000);//3亿，1亿
    } else if (kLotteryIsQixingcai(identifier)){
        sales = 10000000 + arc4random_uniform(10000000);//1千万，1千万
        jackpot = sales + 5000000 + arc4random_uniform(10000000);//5百万，1千万
    } else if (kLotteryIsQilecai(identifier)){
        sales = 5000000 + arc4random_uniform(5000000);//5百万，5百万
        if (random()%2 != 0) {
            jackpot = 1000000 + arc4random_uniform(1000000);//1百万，1百万
        }
    }
    model.sales = [NSString stringWithFormat:@"%lld", sales];
    model.jackpot = [NSString stringWithFormat:@"%lld", jackpot];
    model.radBall = [LotteryDownloadManager getRandomBallByMaxNumber:playRulesModel.radBullRange.length minNumber:playRulesModel.radBullRange.location maxCount:playRulesModel.radBullCount allowDuplicate:playRulesModel.radBullSame isSort:playRulesModel.sortOrder];
    model.blueBall = [LotteryDownloadManager getRandomBallByMaxNumber:playRulesModel.blueBullRange.length minNumber:playRulesModel.blueBullRange.location maxCount:playRulesModel.blueBullCount allowDuplicate:playRulesModel.blueBullSame isSort:playRulesModel.sortOrder];
}

+ (void)setLotteryWinningModelPrize:(LotteryWinningModel *)model playRulesModel:(LotteryPlayRulesModel *)playRulesModel {
    NSMutableArray <LotteryPrizeModel *> *prizeModels = [@[] mutableCopy];
    double percentage = [playRulesModel.percentage doubleValue];
    //可用奖金总额
    double sales = [model.sales doubleValue]*percentage;
    //去掉固定奖剩余奖金总额
    double surplusSales = sales;
    //奖级的奖金为浮动奖金数组
    NSMutableArray *floatSalesArray = [@[] mutableCopy];
    for (LotteryPrizeInfoModel *prizeInfo in playRulesModel.prizeInfoArray){
        LotteryPrizeModel *prizeModel = [[LotteryPrizeModel alloc] init];
        prizeModel.level = prizeInfo.level;
        //根据规则随机中奖注数
        NSRange lotteryNumberRange = prizeInfo.testBonus.lotteryNumberRange;
        NSUInteger lotteryNum = lotteryNumberRange.location + arc4random_uniform((unsigned int)(lotteryNumberRange.length - lotteryNumberRange.location));
        
        prizeModel.number = [NSString stringWithFormat:@"%ld", lotteryNum];
        prizeModel.bonus = prizeInfo.bonus;
        if ([prizeInfo.bonus isEqualToString:@""]){
            //储存浮动奖金的奖级、百分比及最大奖金字典
            NSMutableDictionary *floatSalesDict = [@{} mutableCopy];
            if (![prizeInfo.testBonus.bonus isEqualToString:@""]){
                floatSalesDict[@"maxBonus"] = prizeInfo.testBonus.bonus;
            }
            
            floatSalesDict[@"percentage"] = prizeInfo.testBonus.percentage;
            floatSalesDict[@"level"] = prizeInfo.level;
            
            [floatSalesArray addObject:floatSalesDict];
        }
        [prizeModels addObject:prizeModel];
        double tempSales = [prizeInfo.bonus doubleValue] * lotteryNum;
        surplusSales -= tempSales;
    }
    for (LotteryPrizeModel *prizeModel in prizeModels){
        if (![prizeModel.bonus isEqualToString:@""]) continue;
        for (NSDictionary *dict in floatSalesArray){
            if ([prizeModel.level isEqualToString:[dict objectForKey:@"level"]]){
                double maxBonus = 1e16;
                if ([dict objectForKey:@"maxBonus"]){
                    maxBonus = [[dict objectForKey:@"maxBonus"] doubleValue];
                }
                double percentage = [[dict objectForKey:@"percentage"] doubleValue];
                long long bonus = (surplusSales*percentage)/[prizeModel.number integerValue];
                if (bonus > maxBonus){
                    bonus = maxBonus;
                }
                prizeModel.bonus = [NSString stringWithFormat:@"%lld", bonus];
                [floatSalesArray removeObject:dict];
                break;
            }
        }
        if (floatSalesArray.count == 0) break;
    }
    model.prizeArray = prizeModels;
//    if (kLotteryIsShuangseqiu(identifier)){
//        /*
//         一等奖(奖金总额10%，单注最多1000W，中奖注数0-20)，二等奖(奖金为总额3%，中奖注数70-500)，三等奖(单注奖金3000，中奖注数500-3000)，
//         四等奖(单注奖金200，中奖注数4w-15w)，五等奖(单注奖金10，中奖注数90w-200w)，六等奖(单注奖金5，中奖注数700w-2500w)
//         */
//    } else if (kLotteryIsDaletou(identifier)){
//        /*
//         一等奖(奖金总额10%，单注最多1000W，中奖注数0-20)，二等奖(奖金为总额3%，中奖注数50-200)，三等奖(单注奖金10000，中奖注数100-500)，
//         四等奖(单注奖金3000，中奖注数300-1400)，五等奖(单注奖金300，中奖注数9000-3w)，六等奖(单注奖金200，中奖注数1w5-4w)，
//         七等奖(单注奖金100，中奖注数2w-7w)，八等奖(单注奖金15，中奖注数40w-100w)，九等奖(单注奖金5，中奖注数500w-1000w)
//         */
//    } else if (kLotteryIsFucai3d(identifier)){
//        //直选(单注奖金1040)，组选三(单注奖金346)，组选六(单注奖金173) (中奖注数2000-15000，中奖号码有两个相则同组六位0，否则组三为0)
//    } else if (kLotteryIsPailie3(identifier)){
//        //直选(单注奖金1040)，组选三(单注奖金346)，组选六(单注奖金173) (中奖注数2000-15000，中奖号码有两个相同则组六位0，否则组三为0)
//    } else if (kLotteryIsPailie5(identifier)){
//        //直选(单注奖金10w，中奖注数10-150)
//    } else if (kLotteryIsQixingcai(identifier)){
//        /*
//         一等奖(奖金总额30%，最多500W，中奖注数0-10)，二等奖(奖金为总额3%，中奖注数0-50)，三等奖(单注奖金1800，中奖注数100-200)，四等奖（单注奖金300，中奖注数1000-3000）
//         五等奖(单注奖金20，中奖注数20000-40000)，六等奖(单注奖金5，中奖注数20w-50w)
//        */
//    } else if (kLotteryIsQilecai(identifier)){
//        /*
//         一等奖(奖金总额30%，最多500W，中奖注数0-5)，二等奖(奖金为总额3%，中奖注数0-50)，三等奖(奖金为总额6%，中奖注数100-400)，
//         四等奖(单注奖金200，中奖注数400-1500)，五等奖(单注奖金50，中奖注数5000-15000)，六等奖(单注奖金10，中奖注数8000-23000)，
//         七等奖(单注奖金5，中奖注数6w-15w)
//         */
//    }
}

+ (NSString *)getTestNumber:(NSString *)identifier{
    if ([identifier isEqualToString:@"fucai3d"]){
        NSString *testNumber = [LotteryDownloadManager getRandomBallByMaxNumber:9 minNumber:0 maxCount:3 allowDuplicate:YES isSort:NO];
        NSString *doneTestNumber = @"";
        for (int i = 0; i < testNumber.length; i++) {
            doneTestNumber = [doneTestNumber stringByAppendingString:[testNumber substringWithRange:NSMakeRange(i, 1)]];
            if (i%2 == 1 && i+1 != testNumber.length) {
                doneTestNumber = [NSString stringWithFormat:@"%@ ", doneTestNumber];
            }
        }
    }
    return @"";
}

+ (NSString *)getIssueNumber:(NSInteger)number{
    number = number + 1;
    if (number > 0 && number < 10){
        return [NSString stringWithFormat:@"2000%ld期", number];
    }
    if (number >= 10 && number < 100){
        return [NSString stringWithFormat:@"200%ld期", number];
    }
    return [NSString stringWithFormat:@"20%ld期", number];
}

+ (NSString *)getRandomBallByMaxNumber:(NSInteger)maxNumber minNumber:(NSInteger)minNumber maxCount:(NSInteger)maxCount allowDuplicate:(BOOL)allowDuplicate isSort:(BOOL)isSort{
    NSMutableSet *set = [NSMutableSet setWithCapacity:maxCount];
    if (allowDuplicate){
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        while (array.count < maxCount) {
            NSInteger value = arc4random() % (maxNumber - minNumber + 1) + minNumber;
            [array addObject:[NSNumber numberWithInteger:value]];
        }
        set = [NSMutableSet setWithArray:array];
    } else {
        while (set.count < maxCount) {
            NSInteger value = arc4random() % (maxNumber - minNumber + 1) + minNumber;
            [set addObject:[NSNumber numberWithInteger:value]];
        }
    }
    NSArray *sortSetArray = [set allObjects];
    if (isSort){
        NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:YES]];
        sortSetArray = [set sortedArrayUsingDescriptors:sortDesc];
    }
    NSString *ballStr = @"";
    for (NSUInteger i = 0; i < sortSetArray.count; i++){
        if (i != 0){
            ballStr = [ballStr stringByAppendingString:@","];
        }
        NSInteger number =  [sortSetArray[i] integerValue];
        NSString *numberStr = [NSString stringWithFormat:@"%ld", number];
        if (number < 10){
            numberStr = [NSString stringWithFormat:@"0%@", numberStr];
        }
        ballStr = [ballStr stringByAppendingString:numberStr];
    }
    return ballStr;
}
@end
