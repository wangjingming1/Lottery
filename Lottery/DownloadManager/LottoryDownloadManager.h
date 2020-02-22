//
//  LottoryDownloadManager.h
//  Lottery
//
//  Created by wangjingming on 2020/1/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LottoryWinningModel;
NS_ASSUME_NONNULL_BEGIN

@interface LottoryDownloadManager : NSObject
+ (void)lottoryDownload:(NSInteger)begin count:(NSInteger)count identifiers:(NSArray *)identifiers finsh:(void (^)(NSArray *lottorys))finsh;


#pragma mark - test
+ (NSArray <LottoryWinningModel *> *)lottoryWinningModelRandomizedByIdentifier:(NSString *)identifier begin:(NSInteger)begin  number:(NSInteger)number;
@end

NS_ASSUME_NONNULL_END
