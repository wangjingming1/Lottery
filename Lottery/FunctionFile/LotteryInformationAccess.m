//
//  LotteryInformationAccess.m
//  Lottery
//
//  Created by wangjingming on 2020/3/17.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LotteryInformationAccess.h"
#import "GlobalDefines.h"

@implementation LotteryInformationAccess
+ (void)setLotteryViewingHistory:(NSString *)lotteryIde{
    NSMutableArray *array = [[LotteryInformationAccess getLotteryViewingHistoryArray] mutableCopy];
    if (!array){
        array = [@[] mutableCopy];;
    }
    [array removeObject:lotteryIde];
    [array addObject:lotteryIde];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:kLSVCViewingHistory];
}

+ (NSArray *)getLotteryViewingHistoryArray{
    NSArray *viewingHistoryArray = [[NSUserDefaults standardUserDefaults] objectForKey:kLSVCViewingHistory];
    return viewingHistoryArray;
}
@end
