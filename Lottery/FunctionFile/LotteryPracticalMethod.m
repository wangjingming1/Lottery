//
//  LotteryPracticalMethod.m
//  Lottery
//
//  Created by wangjingming on 2020/2/25.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryPracticalMethod.h"

@implementation LotteryPracticalMethod

#pragma mark 数字 -
//将number转换成以百为单位
+ (double)hundred:(long long)number {
    return number/100.0;
}

//将number转换成以千为单位
+ (double)thousand:(long long)number {
    return [LotteryPracticalMethod hundred:number] / 10.0;
}

//将number转换成以万为单位
+ (double)tenThousand:(long long)number {
    return [LotteryPracticalMethod hundred:[LotteryPracticalMethod hundred:number]];
}

//将number转换成以亿为单位
+ (double)hundredMillion:(long long)number {
    return [LotteryPracticalMethod tenThousand:[LotteryPracticalMethod tenThousand:number]];
}

//将number转成最大单位(即1万-9999万，1亿到9999亿)，保留dp位小数
+ (NSString *)getMaxUnitText:(long long)number withPrecisionNum:(NSInteger)precision {
    if (number < 10000){
        return [NSString stringWithFormat:@"%lld", number];
    }
    NSString *unit = @"";
    double other = number;
    //生成format格式
    NSString *format = [NSString stringWithFormat:@"%%.%ldf",(long)precision];
    if (number < 100000000){
        unit = @"万";
        other = [LotteryPracticalMethod tenThousand:number];
    } else {
        unit = @"亿";
        other = [LotteryPracticalMethod hundredMillion:number];
    }
    NSString *otherValue = [NSString stringWithFormat:format, other];
    return [NSString stringWithFormat:@"%@%@", otherValue, unit];
}
#pragma mark 时间 -
+ (NSArray <NSString *> *)getWeekdayArray{
    return @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
}
/*!
    由于西方一周的开始是从周日开始算的和我们不一样，我们一周的开始是周一，在初始化日期数组的时候一定要从周日开始
 */
+ (NSString *)weekdayStringWithDate:(NSDate *)date {
    //获取周几
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [componets weekday];//1代表周日，2代表周一，后面依次
    NSArray *weekArray = [LotteryPracticalMethod getWeekdayArray];
    NSString *weekStr = weekArray[weekday-1];
    return weekStr;
}

#pragma mark 随机数 -
+ (NSString *)arc4random:(int)number {
    NSString *str = @"";
    for (int i = 0; i < number; i++){
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%d", arc4random_uniform(10)]];
    }
    return str;
}
@end
