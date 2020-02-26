//
//  NSDate+ExtendedDate.h
//  Lottery
//
//  Created by wangjingming on 2020/2/25.
//  Copyright © 2020 wangjingming. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ExtendedDate)
/*! 获取指定date是星期几 */
- (NSString *)weekdayStringWithDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
