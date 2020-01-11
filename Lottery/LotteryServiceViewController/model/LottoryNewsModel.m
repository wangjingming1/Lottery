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
#pragma mark - test
+ (NSArray *)geTestLottoryNewsModelArray:(NSInteger)begin count:(NSInteger)count{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res" ofType:@"json"];
    
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *jsonData = [readHandle readDataToEndOfFile];
    
//    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    NSArray *datas = [dic objectForKey:@"data"];
    NSInteger i = begin;
    while (count > 0) {
        NSDictionary *dict = datas[i++%datas.count];
        LottoryNewsModel *model = [[LottoryNewsModel alloc] init];
        model.informationSources = [dict objectForKey:@"informationSources"];
        model.time = [dict objectForKey:@"time"];
        model.title = [dict objectForKey:@"title"];
        model.imageUrl = [dict objectForKey:@"imageUrl"];
        model.newsUrl = [dict objectForKey:@"url"];
        [array addObject:model];
        count--;
    }
    return array;
}
@end
