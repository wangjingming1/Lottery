//
//  LotteryPlayRulesModel.h
//  Lottery
//
//  Created by wangjingming on 2020/2/25.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LotteryPrizeInfoModel;
@class LotteryWinningRulesModel;
@class LotteryTestBonus;

/**彩票玩法及中奖规则*/
@interface LotteryPlayRulesModel : NSObject
/**彩票标示码*/
@property (nonatomic, copy) NSString *identifier;
/**彩票种类*/
@property (nonatomic, copy) NSString *kindName;
/**是否按序排列*/
@property (nonatomic) BOOL sortOrder;
/**用来界面显示的开奖时间文本*/
@property (nonatomic, copy) NSString *lotteryShowTime;
/**开奖时间*/
@property (nonatomic, copy) NSString *lotteryTime;

/**中奖规则数组，默认按奖级从大到小排列*/
@property (nonatomic, strong) NSArray <LotteryPrizeInfoModel *> *prizeInfoArray;

/**红球是否允许重复*/
@property (nonatomic) BOOL radBullSame;
/**红球范围*/
@property (nonatomic) NSRange radBullRange;
/**红球数量*/
@property (nonatomic) NSInteger radBullCount;

/**蓝球是否允许重复*/
@property (nonatomic) BOOL blueBullSame;
/**蓝球范围*/
@property (nonatomic) NSRange blueBullRange;
/**蓝球数量*/
@property (nonatomic) NSInteger blueBullCount;

/**ps：测试用奖金占销售额的百分比*/
@property (nonatomic, copy) NSString *percentage;
+ (LotteryPlayRulesModel *)initLotteryPlayRulesModelWithDict:(NSDictionary *)dict;
@end

#pragma mark -
/**奖级，奖品及中奖规则*/
@interface LotteryPrizeInfoModel : NSObject
/**奖级*/
@property (nonatomic, copy) NSString *level;
/**奖金(元)*/
@property (nonatomic, copy) NSString *bonus;
/**获得该奖级需要的条件*/
@property (nonatomic, strong) NSArray <LotteryWinningRulesModel *> *winningRulesArray;

/**该奖级的奖金浮动标准及中奖注数(测试用)*/
@property (nonatomic, strong) LotteryTestBonus *testBonus;
+ (LotteryPrizeInfoModel *)initLotteryPrizeInfoModelWithDict:(NSDictionary *)dict;
@end

#pragma mark -
/**获奖规则*/
@interface LotteryWinningRulesModel : NSObject
/**红球相同数量*/
@property (nonatomic) NSInteger radBullSameCount;
/**蓝球相同数量*/
@property (nonatomic) NSInteger blueBullSameCount;
/**球是否需要连续一致*/
@property (nonatomic) BOOL consistency;
+ (LotteryWinningRulesModel *)initLotteryWinningRulesModelWithDict:(NSDictionary *)dict;
@end

#pragma mark -
/**中奖注数范围及奖金f*/
@interface LotteryTestBonus : NSObject
/**占剩余奖金的百分比*/
@property (nonatomic, copy) NSString *percentage;
/**奖金(如果是浮动奖金该值表示该奖级奖金的最大值)*/
@property (nonatomic, copy) NSString *bonus;
/**中奖注数(范围)*/
@property (nonatomic) NSRange lotteryNumberRange;

+ (LotteryTestBonus *)initLotteryTestBonusWithDict:(NSDictionary *)dict;
@end
NS_ASSUME_NONNULL_END