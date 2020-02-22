//
//  HomePageDownloadManager.m
//  Lottery
//
//  Created by wangjingming on 2020/2/22.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageDownloadManager.h"
#import "HttpManager.h"
#import "GlobalDefines.h"

#import "LottoryDownloadManager.h"

#import "LottoryBannerModel.h"
#import "LottoryConvenientServiceModel.h"
#import "LottoryWinningModel.h"
#import "LottoryNewsModel.h"

@implementation HomePageDownloadManager

+ (void)homePageDownloadData:(void (^)(NSDictionary *datas))finsh {
    #ifdef kTEST
        NSDictionary *datas = [HomePageDownloadManager geTestHomePageDatas];
        if (finsh){
            finsh(datas);
        }
    #else
    
    #endif
}

#pragma mark - test
+ (NSDictionary *)geTestHomePageDatas{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"homePage" ofType:@"json"];
    
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *jsonData = [readHandle readDataToEndOfFile];
    
    NSError *err;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    NSDictionary *dict = [jsonDict objectForKey:@"data"];
    if (dict && dict.count > 0){
        NSArray *banners = [dict objectForKey:@"banners"];
        NSArray *convenientServices = [dict objectForKey:@"convenientServices"];
        NSArray *winnings = [dict objectForKey:@"winnings"];
        NSArray *news = [dict objectForKey:@"news"];
        
        NSMutableDictionary *datas = [@{} mutableCopy];
        HomePageDownloadManager *manager = [[HomePageDownloadManager alloc] init];
        datas[@"banners"] = [manager getBannerModels:banners];
        datas[@"convenientServices"] = [manager getLottoryConvenientServiceModels:convenientServices];
        datas[@"winnings"] = [manager getLottoryWinningModels:winnings];
        datas[@"news"] = [manager getLottoryNewsModels:news];
        return datas;
    }
    return @{};
}

- (NSArray <LottoryBannerModel *> *)getBannerModels:(NSArray *)datas{
    NSMutableArray *array = [@[] mutableCopy];
    for (NSDictionary *dict in datas){
        LottoryBannerModel *model = [[LottoryBannerModel alloc] initWithDict:dict];
        [array addObject:model];
    }
    return array;
}

- (NSArray <LottoryConvenientServiceModel *> *)getLottoryConvenientServiceModels:(NSArray *)datas{
    NSMutableArray *array = [@[] mutableCopy];
    for (NSDictionary *dict in datas){
        LottoryConvenientServiceModel *model = [[LottoryConvenientServiceModel alloc] initWithDict:dict];
        [array addObject:model];
    }
    return array;
}

- (NSArray <LottoryWinningModel *> *)getLottoryWinningModels:(NSArray *)datas{
    NSMutableArray *array = [@[] mutableCopy];
    for (NSDictionary *dict in datas){
        NSString *identifier = [dict objectForKey:@"identifier"];
        NSString *lottoryDataJson = [dict objectForKey:@"lottoryData"];
        LottoryWinningModel *model;
        if ([lottoryDataJson isEqualToString:@"test"]){
            NSArray *array = [LottoryDownloadManager lottoryWinningModelRandomizedByIdentifier:identifier begin:0 number:1];
            model = [array firstObject];
        } else {
            NSData *jsonData = [lottoryDataJson dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *lottoryDataDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            
            model = [[LottoryWinningModel alloc] initWithDict:lottoryDataDict];
        }
        model.identifier = identifier;
        [array addObject:model];
    }
    return array;
}

- (NSArray <LottoryNewsModel *> *)getLottoryNewsModels:(NSArray *)datas{
    NSMutableArray *array = [@[] mutableCopy];
    for (NSDictionary *dict in datas){
        LottoryNewsModel *model = [[LottoryNewsModel alloc] initWithDict:dict];
        [array addObject:model];
    }
    return array;
}
@end
