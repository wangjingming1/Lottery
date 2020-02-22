//
//  HPVCHeaderView.m
//  Lottery
//
//  Created by wangjingming on 2020/1/2.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "HPVCHeaderView.h"
#import "LotteryBannerView.h"
#import "AFNetworking.h"
#import "GlobalDefines.h"
#import "Masonry.h"
#import "WebViewController.h"
#import "LottoryBannerModel.h"

@interface HPVCHeaderView()<LotteryBannerViewDelegate>
@property (nonatomic, strong) NSArray *modelArray;
@end

@implementation HPVCHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (LotteryBannerView *)bannerView{
    if (_bannerView) return _bannerView;
    LotteryBannerView *bannerView = [[LotteryBannerView alloc] init];
    bannerView.delegate = self;
    [self addSubview:bannerView];
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(100);
        make.bottom.mas_equalTo(0);
    }];
    
    
    _bannerView = bannerView;
    return _bannerView;
}

- (void)reloadBannerView:(NSArray *)datas{
    [self setModelArray:datas];
    [self downloadBannerImages];
}

- (void)downloadBannerImages{
////    NSDictionary *params = @{};
////    NSString *url = @"";
////    [[AFHTTPSessionManager manager] GET:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////
////    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////
////    }];
//
//    NSLog(@"%@", kDocumentsPath);
//    NSMutableArray *images = [@[@"banner_1", @"banner_2", @"banner_3"] mutableCopy];
//    NSString *documentsPath = kDocumentsPath;
//    NSString *bannerPath = [NSString stringWithFormat:@"%@/homePage/banner", documentsPath];
//    for (NSString *str in images){
//        UIImage *image = [UIImage imageNamed:str];
//        if (!image) continue;
//        NSString *filePath = [NSString stringWithFormat:@"%@/%@.png", bannerPath, str];
//        BOOL result = [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]; // 保存成功会返回YES
//        if (result == YES) {
//            NSLog(@"保存成功");
//        }
//    }
    NSMutableArray *images = [@[] mutableCopy];
    for (LottoryBannerModel *model in self.modelArray){
        [images addObject:model.image];
    }
    [self.bannerView setImageArray:images];
}

#pragma mark - LotteryBannerViewDelegate
- (void)selectImage:(LotteryBannerView *)bannerView currentImage:(NSInteger)currentImage {
    if (!self.modelArray || self.modelArray.count <= currentImage) return;
    if (!_delegate || ![_delegate respondsToSelector:@selector(pushViewController:params:)]) return;
    
    LottoryBannerModel *model = self.modelArray[currentImage];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    params[@"leftTitle"] = @"赛事中心";
    params[@"url"] = model.url;
    [self.delegate pushViewController:[WebViewController class] params:params];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
