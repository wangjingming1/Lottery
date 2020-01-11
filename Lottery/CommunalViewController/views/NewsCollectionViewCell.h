//
//  NewsCollectionViewCell.h
//  Lottery
//
//  Created by wangjingming on 2020/1/8.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LottoryNewsModel;
@interface NewsCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) LottoryNewsModel *model;
@end

NS_ASSUME_NONNULL_END
