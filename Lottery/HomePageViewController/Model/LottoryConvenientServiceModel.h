//
//  LottoryConvenientServiceModel.h
//  Lottery
//
//  Created by wangjingming on 2020/2/22.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LottoryConvenientServiceModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *className;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
