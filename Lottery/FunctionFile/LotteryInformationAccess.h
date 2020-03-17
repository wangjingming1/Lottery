//
//  LotteryInformationAccess.h
//  Lottery
//
//  Created by wangjingming on 2020/3/17.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LotteryInformationAccess : NSObject
+ (void)setLotteryViewingHistory:(NSString *)lotteryIde;
+ (NSArray *)getLotteryViewingHistoryArray;
@end

NS_ASSUME_NONNULL_END
