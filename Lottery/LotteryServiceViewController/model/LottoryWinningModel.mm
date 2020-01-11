//
//  LottoryWinningModel.m
//  Lottery
//
//  Created by wangjingming on 2020/1/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LottoryWinningModel.h"

@implementation LottoryWinningModel

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
    }
    return self;
}

#pragma mark - test
+ (NSArray <LottoryWinningModel *> *)lottoryWinningModelRandomizedByIdentifier:(NSString *)identifier number:(NSInteger)number{
    NSMutableArray <LottoryWinningModel *> *array = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *icon = [LottoryWinningModel identifierToString:identifier type:@"icon"];
    NSString *name = [LottoryWinningModel identifierToString:identifier type:@"name"];
    for (NSInteger i = 0; i < number; i++){
        LottoryWinningModel *model = [[LottoryWinningModel alloc] init];
        model.icon = icon;
        model.kindName = name;
        model.issueNumber = [LottoryWinningModel getIssueNumber:i];
        model.date = [LottoryWinningModel getDate:-i];
        double sales = 100000000 + arc4random_uniform(999999999);
        model.sales = [LottoryWinningModel removeSuffix:[NSString stringWithFormat:@"%.2f", sales/100000000.0]];
        model.jackpot = [LottoryWinningModel removeSuffix:[NSString stringWithFormat:@"%.2f", (sales + 100000000 + arc4random_uniform(999999999))/100000000.0]];
        NSInteger maxBall = 0, minBall = 0, maxCount = 0;
        BOOL allowDuplicate = NO, isSort = NO;
        if ([LottoryWinningModel getBallData:identifier ballColor:@"red" maxBall:maxBall minBall:minBall maxCount:maxCount allowDuplicate:allowDuplicate isSort:isSort]){
            model.radBall = [LottoryWinningModel getRandomBallByMaxNumber:maxBall minNumber:minBall maxCount:maxCount allowDuplicate:allowDuplicate isSort:isSort];
        }
        if ([LottoryWinningModel getBallData:identifier ballColor:@"blue" maxBall:maxBall minBall:minBall maxCount:maxCount allowDuplicate:allowDuplicate isSort:isSort]){
            model.blueBall = [LottoryWinningModel getRandomBallByMaxNumber:maxBall minNumber:minBall maxCount:maxCount allowDuplicate:allowDuplicate isSort:isSort];
        }
        model.testNumber = [LottoryWinningModel getTestNumber:identifier];
        [array addObject:model];
    }
    return array;
}

+ (NSString *)identifierToString:(NSString *)identifier type:(NSString *)type{
    if ([identifier isEqualToString:@"shuangseqiu"]){
        if ([type isEqualToString:@"icon"]) return @"shuangseqiu";
        if ([type isEqualToString:@"name"]) return @"双色球";
    } else if ([identifier isEqualToString:@"daletou"]){
        if ([type isEqualToString:@"icon"]) return @"daletou";
        if ([type isEqualToString:@"name"]) return @"超级大乐透";
    } else if ([identifier isEqualToString:@"fucai3d"]){
        if ([type isEqualToString:@"icon"]) return @"3d";
        if ([type isEqualToString:@"name"]) return @"福彩3D";
    } else if ([identifier isEqualToString:@"pailie3"]){
        if ([type isEqualToString:@"icon"]) return @"pailie3";
        if ([type isEqualToString:@"name"]) return @"排列3";
    } else if ([identifier isEqualToString:@"pailie5"]){
        if ([type isEqualToString:@"icon"]) return @"pailie5";
        if ([type isEqualToString:@"name"]) return @"排列5";
    } else if ([identifier isEqualToString:@"qixingcai"]){
        if ([type isEqualToString:@"icon"]) return @"qixingcai";
        if ([type isEqualToString:@"name"]) return @"七星彩";
    } else if ([identifier isEqualToString:@"qilecai"]){
        if ([type isEqualToString:@"icon"]) return @"qilecai";
        if ([type isEqualToString:@"name"]) return @"七乐彩";
    }
    return @"";
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
        NSString *testNumber = [LottoryWinningModel getRandomBallByMaxNumber:9 minNumber:0 maxCount:3 allowDuplicate:YES isSort:NO];
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
