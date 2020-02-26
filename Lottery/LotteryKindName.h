//
//  LotteryKindName.h
//  Lottery
//
//  Created by wangjingming on 2020/2/26.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#ifndef LotteryKindName_h
#define LotteryKindName_h

#define kLotteryKindName_daletou        @"daletou"
#define kLotteryKindName_shuangseqiu    @"shuangseqiu"
#define kLotteryKindName_fucai3d        @"fucai3d"
#define kLotteryKindName_pailie3        @"pailie3"
#define kLotteryKindName_pailie5        @"pailie5"
#define kLotteryKindName_qixingcai      @"qixingcai"
#define kLotteryKindName_qilecai        @"qilecai"

#define kLotteryIsDaletou(identifier)       [identifier isEqualToString:kLotteryKindName_daletou]
#define kLotteryIsShuangseqiu(identifier)   [identifier isEqualToString:kLotteryKindName_shuangseqiu]
#define kLotteryIsFucai3d(identifier)       [identifier isEqualToString:kLotteryKindName_fucai3d]
#define kLotteryIsPailie3(identifier)       [identifier isEqualToString:kLotteryKindName_pailie3]
#define kLotteryIsPailie5(identifier)       [identifier isEqualToString:kLotteryKindName_pailie5]
#define kLotteryIsQixingcai(identifier)     [identifier isEqualToString:kLotteryKindName_qixingcai]
#define kLotteryIsQilecai(identifier)       [identifier isEqualToString:kLotteryKindName_qilecai]

#endif /* LotteryKindName_h */
