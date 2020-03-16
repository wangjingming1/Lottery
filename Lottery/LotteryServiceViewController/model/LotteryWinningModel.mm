//
//  LotteryWinningModel.m
//  Lottery
//
//  Created by wangjingming on 2020/1/5.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryWinningModel.h"
#import "LotteryKindName.h"
#import "LotteryPracticalMethod.h"
#import "GlobalDefines.h"
#import "LotteryKeyword.h"
#import "LotteryPlayRulesModel.h"

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
        self.newest = NO;
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

- (NSString *)dateToGeneralFormat{
    NSDateFormatter *originFormatter = [[NSDateFormatter alloc]init];
    [originFormatter setDateFormat:kDefaultDateFormat];
    NSDate *date = [originFormatter dateFromString:self.date];
    
    NSDateFormatter *otherFormatter = [[NSDateFormatter alloc]init];
    [otherFormatter setDateFormat:@"MM.dd"];
    NSString *dateStr = [otherFormatter stringFromDate:date];
    NSString *weakday = [LotteryPracticalMethod weekdayStringWithDate:date];
    NSString *newDate = [NSString stringWithFormat:@"%@（%@）", dateStr, weakday];
    return newDate;
}

int combination(int m,int n){
    int k = 1, j = 1;
    for (int i = n; i >= 1; i--){
        k = k*m;
        j = j*n;
        m--;
        n--;
    }
    return k/j;
}

void calculateRed(int red,int guessRed,int blue,int guessBlue, int RED, int BLUE){
   int notGuessBule = blue - guessBlue;
    for(int i=guessRed; i>=0;i--){
        if(red-guessRed+i<RED)
            break;
        int recoreds = combination(guessRed,i)*combination(red-guessRed,RED-i);
        if(recoreds*guessBlue!=0){
            NSLog(@"红球中%d个，篮球中%d个的注数是%d注",i, guessBlue, recoreds*guessBlue);
        }
        if(recoreds*notGuessBule!=0){
            NSLog(@"红球中%d个，篮球中0个的注数是%d注", i, recoreds*notGuessBule);
        }
    }
}

void calculateRed1(int red,int guessRed,int blue,int guessBlue, int RED, int BLUE){
    int notGuessBule = blue - guessBlue;
    for(int i=guessRed; i>=0;i--){
        if(red-guessRed+i<RED)
            break;
        int recoredsRad = combination(guessRed,i)*combination(red-guessRed,RED-i);
        for (int j = guessBlue; j >= 0; j--){
            if (blue - guessBlue + j < BLUE){
                break;
            }
            int recoredsBlue = combination(guessBlue,j)*combination(blue-guessBlue,BLUE-j);
            if(recoredsRad*j!=0){
                NSLog(@"红球中%d个，篮球中%d个的注数是%d注",i, j, recoredsRad*recoredsBlue);
            }
        }
        if(recoredsRad*notGuessBule!=0){
            NSLog(@"红球中%d个，篮球中0个的注数是%d注", i, recoredsRad*notGuessBule);
        }
    }
}

- (NSArray *)calculateRed1:(int)red guessRed:(int)guessRed blue:(int)blue guessBlue:(int)guessBlue RED:(int)RED BLUE:(int)BLUE{
    NSMutableArray *array = [@[] mutableCopy];
    int notGuessBule = blue - guessBlue;
    for(int i = guessRed; i >= 0; i--){
        if(red - guessRed + i < RED)
            break;
        int recoredsRad = combination(guessRed, i)*combination(red - guessRed, RED - i);
        int j = guessBlue;
        for (; j >= 0; j--){
            if (blue - guessBlue + j < BLUE){
                break;
            }
            NSMutableDictionary *dict = [@{} mutableCopy];
            int recoredsBlue = combination(guessBlue, j)*combination(blue - guessBlue, BLUE - j);
            if(recoredsRad*j != 0){
                NSLog(@"红球中%d个，篮球中%d个的注数是%d注",i, j, recoredsRad*recoredsBlue);
                dict[@"guessRed"] = @(i);
                dict[@"guessBlue"] = @(j);
                dict[@"count"] = @(recoredsRad*recoredsBlue);
                [array addObject:dict];
            }
        }
        if(recoredsRad*notGuessBule!=0 && notGuessBule > BLUE){
            int recoreds = combination(notGuessBule, BLUE);
            NSMutableDictionary *dict = [@{} mutableCopy];
            NSLog(@"红球中%d个，篮球中0个的注数是%d注", i, recoredsRad*recoreds);
            dict[@"guessRed"] = @(i);
            dict[@"guessBlue"] = @(0);
            dict[@"count"] = @(recoredsRad*recoreds);
            [array addObject:dict];
        }
    }
    return array;
}

- (NSArray <LotteryPrizeModel *> *)calculatorPrizeArrayWithSelectRadCount:(NSString *)selectRadCount selectBlueCount:(NSString *)selectBlueCount guessRadCount:(NSString *)guessRadCount guessBlueCount:(NSString *)guessBlueCount{
    NSArray *calculateArray = [self calculateRed1:[selectRadCount intValue] guessRed:[guessRadCount intValue] blue:[selectBlueCount intValue] guessBlue:[guessBlueCount intValue] RED:(int)self.playRulesModel.radBullCount BLUE:(int)self.playRulesModel.blueBullCount];
    auto findLotteryPrizeModel = [self](NSString *level){
        LotteryPrizeModel *prizeModel;
        for (LotteryPrizeModel *model in self.prizeArray){
            if ([model.level isEqualToString:level]){
                prizeModel = model;
                break;
            }
        }
        return prizeModel;
    };
    
    NSMutableArray <LotteryPrizeModel *> *prizeArray = [@[] mutableCopy];
    for (LotteryPrizeInfoModel *infoModel in self.playRulesModel.prizeInfoArray){
        LotteryPrizeModel *existingModel = findLotteryPrizeModel(infoModel.level);
        if (!existingModel) continue;
        LotteryPrizeModel *model = [[LotteryPrizeModel alloc] init];
        model.level = infoModel.level;
        model.bonus = existingModel.bonus;
        NSInteger count = 0;
        for (LotteryWinningRulesModel *rulesModel in infoModel.winningRulesArray){
            for (NSDictionary *dict in calculateArray){
                NSInteger guessRed = [dict[@"guessRed"] integerValue];
                NSInteger guessBlue = [dict[@"guessBlue"] integerValue];
                NSInteger guessCount = [dict[@"count"] integerValue];
                if (guessRed == rulesModel.radBullSameCount && guessBlue == rulesModel.blueBullSameCount){
                    count += guessCount;
                }
            }
        }
        model.number = [NSString stringWithFormat:@"%ld", count];
        [prizeArray addObject:model];
    }
    return prizeArray;
}

- (LotteryPrizeModel *)calculatorPrize:(LotteryPrizeInfoModel *)originModel selectRadCount:(NSString *)selectRadCount selectBlueCount:(NSString *)selectBlueCount targerRadCount:(NSString *)targetRadCount targetBlueCount:(NSString *)targetBlueCount{
    LotteryPrizeModel *targetModel = [[LotteryPrizeModel alloc] init];
    targetModel.level = originModel.level;
    
    return targetModel;
}

#pragma mark - test
+ (NSString *)identifierToString:(NSString *)identifier type:(NSString *)type{
    LotteryKeyword *keyword = [[LotteryKeyword alloc] init];
    NSString *str = [keyword identifierToType:type identifier:identifier];;
    return str;
//    if (kLotteryIsShuangseqiu(identifier)){
//        if ([type isEqualToString:@"icon"]) return @"shuangseqiu";
//        if ([type isEqualToString:@"name"]) return @"双色球";
//    } else if (kLotteryIsDaletou(identifier)){
//        if ([type isEqualToString:@"icon"]) return @"daletou";
//        if ([type isEqualToString:@"name"]) return @"超级大乐透";
//    } else if (kLotteryIsFucai3d(identifier)){
//        if ([type isEqualToString:@"icon"]) return @"3d";
//        if ([type isEqualToString:@"name"]) return @"福彩3D";
//    } else if (kLotteryIsPailie3(identifier)){
//        if ([type isEqualToString:@"icon"]) return @"pailie3";
//        if ([type isEqualToString:@"name"]) return @"排列3";
//    } else if (kLotteryIsPailie5(identifier)){
//        if ([type isEqualToString:@"icon"]) return @"pailie5";
//        if ([type isEqualToString:@"name"]) return @"排列5";
//    } else if (kLotteryIsQixingcai(identifier)){
//        if ([type isEqualToString:@"icon"]) return @"qixingcai";
//        if ([type isEqualToString:@"name"]) return @"七星彩";
//    } else if (kLotteryIsQilecai(identifier)){
//        if ([type isEqualToString:@"icon"]) return @"qilecai";
//        if ([type isEqualToString:@"name"]) return @"七乐彩";
//    }
//    return @"";
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
