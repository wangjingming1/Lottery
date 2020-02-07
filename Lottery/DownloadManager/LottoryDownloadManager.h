//
//  LottoryDownloadManager.h
//  Lottery
//
//  Created by wangjingming on 2020/1/18.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LottoryDownloadManager : NSObject
+ (void)lottoryDownload:(NSInteger)begin count:(NSInteger)count identifiers:(NSArray *)identifiers finsh:(void (^)(NSArray *lottorys))finsh;
@end

NS_ASSUME_NONNULL_END
