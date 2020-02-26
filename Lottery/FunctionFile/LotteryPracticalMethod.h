//
//  LotteryPracticalMethod.h
//  Lottery
//  单位转换
//  Created by wangjingming on 2020/2/25.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LotteryPracticalMethod : NSObject
/**将number转换成以百为单位*/
+ (double)hundred:(long long)number;
/**将number转换成以千为单位*/
+ (double)thousand:(long long)number;
/**将number转换成以万为单位*/
+ (double)tenThousand:(long long)number;
/**将number转换成以亿为单位*/
+ (double)hundredMillion:(long long)number;
/**
 将number转成最大单位(暂时只支持 1万-9999万，1亿到9999亿)
 保留precision位小数
 */
+ (NSString *)getMaxUnitText:(long long)number withPrecisionNum:(NSInteger)precision;

/*! 返回@[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"]*/
+ (NSArray <NSString *> *)getWeekdayArray;
/*! 获取指定date是星期几 */
+ (NSString *)weekdayStringWithDate:(NSDate *)date;

/*! 生成一个number位的随机数*/
+ (NSString *)arc4random:(int)number;
@end

NS_ASSUME_NONNULL_END
