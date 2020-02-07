//
//  LottoryDownloadManager.m
//  Lottery
//
//  Created by wangjingming on 2020/1/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LottoryDownloadManager.h"
#import "HttpManager.h"

#import "LottoryWinningModel.h"

@implementation LottoryDownloadManager

+ (void)lottoryDownload:(NSInteger)begin count:(NSInteger)count identifiers:(NSArray *)identifiers finsh:(void (^)(NSArray *lottorys))finsh {
#ifdef kTEST
    NSMutableArray *lottorys = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *ide in identifiers){
        NSArray *array = [LottoryDownloadManager lottoryWinningModelRandomizedByIdentifier:ide begin:begin number:count];
        [lottorys addObjectsFromArray:array];
    }
    if (finsh){
        finsh(lottorys);
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
        LottoryWinningModel *model = [[LottoryWinningModel alloc] initWithDict:dic];
        [array addObject:model];
    }];
#endif
}

#pragma mark - test
+ (NSArray <LottoryWinningModel *> *)lottoryWinningModelRandomizedByIdentifier:(NSString *)identifier begin:(NSInteger)begin  number:(NSInteger)number{
    NSMutableArray <LottoryWinningModel *> *array = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *icon = [LottoryWinningModel identifierToString:identifier type:@"icon"];
    NSString *name = [LottoryWinningModel identifierToString:identifier type:@"name"];
    for (NSInteger i = begin; i < begin + number; i++){
        LottoryWinningModel *model = [[LottoryWinningModel alloc] init];
        model.icon = icon;
        model.kindName = name;
        model.issueNumber = [LottoryDownloadManager getIssueNumber:i];
        model.date = [LottoryDownloadManager getDate:-i];
        double sales = 100000000 + arc4random_uniform(999999999);
        model.sales = [LottoryDownloadManager removeSuffix:[NSString stringWithFormat:@"%.2f", sales/100000000.0]];
        model.jackpot = [LottoryDownloadManager removeSuffix:[NSString stringWithFormat:@"%.2f", (sales + 100000000 + arc4random_uniform(999999999))/100000000.0]];
        NSInteger maxBall = 0, minBall = 0, maxCount = 0;
        BOOL allowDuplicate = NO, isSort = NO;
        if ([LottoryDownloadManager getBallData:identifier ballColor:@"red" maxBall:maxBall minBall:minBall maxCount:maxCount allowDuplicate:allowDuplicate isSort:isSort]){
            model.radBall = [LottoryDownloadManager getRandomBallByMaxNumber:maxBall minNumber:minBall maxCount:maxCount allowDuplicate:allowDuplicate isSort:isSort];
        }
        if ([LottoryDownloadManager getBallData:identifier ballColor:@"blue" maxBall:maxBall minBall:minBall maxCount:maxCount allowDuplicate:allowDuplicate isSort:isSort]){
            model.blueBall = [LottoryDownloadManager getRandomBallByMaxNumber:maxBall minNumber:minBall maxCount:maxCount allowDuplicate:allowDuplicate isSort:isSort];
        }
        model.testNumber = [LottoryDownloadManager getTestNumber:identifier];
        [array addObject:model];
    }
    return array;
}

+ (BOOL)getBallData:(NSString *)identifier ballColor:(NSString *)ballColor maxBall:(NSInteger &)maxBall minBall:(NSInteger &)minBall maxCount:(NSInteger &)maxCount allowDuplicate:(BOOL &)allowDuplicate isSort:(BOOL &)isSort{
    if ([identifier isEqualToString:@"shuangseqiu"]){
        if ([ballColor isEqualToString:@"red"]) {
            minBall = 1;
            maxBall = 33;
            maxCount = 6;
        } else if ([ballColor isEqualToString:@"blue"]) {
            minBall = 1;
            maxBall = 16;
            maxCount = 1;
        }
        allowDuplicate = NO;
        isSort = YES;
        return YES;
    } else if ([identifier isEqualToString:@"daletou"]){
        if ([ballColor isEqualToString:@"red"]) {
            minBall = 1;
            maxBall = 35;
            maxCount = 5;
        } else if ([ballColor isEqualToString:@"blue"]) {
            minBall = 1;
            maxBall = 12;
            maxCount = 2;
        }
        allowDuplicate = NO;
        isSort = YES;
        return YES;
    } else if ([identifier isEqualToString:@"fucai3d"]){
        if ([ballColor isEqualToString:@"red"]) {
            minBall = 0;
            maxBall = 9;
            maxCount = 3;
        } else if ([ballColor isEqualToString:@"blue"]) {
            maxCount = 0;
        }
        allowDuplicate = YES;
        isSort = NO;
        return YES;
    } else if ([identifier isEqualToString:@"pailie3"]){
        if ([ballColor isEqualToString:@"red"]) {
            minBall = 0;
            maxBall = 9;
            maxCount = 3;
        } else if ([ballColor isEqualToString:@"blue"]) {
            maxCount = 0;
        }
        allowDuplicate = YES;
        isSort = NO;
        return YES;
    } else if ([identifier isEqualToString:@"pailie5"]){
        if ([ballColor isEqualToString:@"red"]) {
            minBall = 0;
            maxBall = 9;
            maxCount = 5;
        } else if ([ballColor isEqualToString:@"blue"]) {
            maxCount = 0;
        }
        allowDuplicate = YES;
        isSort = NO;
        return YES;
    } else if ([identifier isEqualToString:@"qixingcai"]){
        if ([ballColor isEqualToString:@"red"]) {
            minBall = 0;
            maxBall = 9;
            maxCount = 7;
        } else if ([ballColor isEqualToString:@"blue"]) {
            maxCount = 0;
        }
        allowDuplicate = YES;
        isSort = NO;
        return YES;
    } else if ([identifier isEqualToString:@"qilecai"]){
        if ([ballColor isEqualToString:@"red"]) {
            minBall = 1;
            maxBall = 30;
            maxCount = 7;
        } else if ([ballColor isEqualToString:@"blue"]) {
            minBall = 1;
            maxBall = 30;
            maxCount = 1;
        }
        allowDuplicate = NO;
        isSort = YES;
        return YES;
    }
    return NO;
}

+ (NSString *)getTestNumber:(NSString *)identifier{
    if ([identifier isEqualToString:@"fucai3d"]){
        NSString *testNumber = [LottoryDownloadManager getRandomBallByMaxNumber:9 minNumber:0 maxCount:3 allowDuplicate:YES isSort:NO];
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

+ (NSString *)getDate:(NSInteger)dateOffset{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval days = 24 * 60 * 60 * dateOffset;  // 一天一共有多少秒
    NSDate *appointDate = [currentDate dateByAddingTimeInterval:days];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM.dd"];
    //获取当前时间日期展示字符串 如：05.23
    NSString *str = [formatter stringFromDate:appointDate];
    return str;
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

+ (NSString *)removeSuffix:(NSString *)numberStr{
    if (numberStr.length > 1) {
        if ([numberStr componentsSeparatedByString:@"."].count == 2) {
            NSString *last = [numberStr componentsSeparatedByString:@"."].lastObject;
            if ([last isEqualToString:@"00"]) {
                numberStr = [numberStr substringToIndex:numberStr.length - (last.length + 1)];
                return numberStr;
            }else{
                if ([[last substringFromIndex:last.length -1] isEqualToString:@"0"]) {
                    numberStr = [numberStr substringToIndex:numberStr.length - 1];
                    return numberStr;
                }
            }
        }
        return numberStr;
    }
    return numberStr;
}

@end
