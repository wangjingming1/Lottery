//
//  LottoryNewsModel.m
//  Lottery
//
//  Created by wangjingming on 2020/1/9.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "LottoryNewsModel.h"

@implementation LottoryNewsModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.informationSources = @"";
        self.time = @"";
        self.title = @"";
        self.imageUrl = @"";
        self.newsUrl = @"";
    }
    return self;
}
@end
