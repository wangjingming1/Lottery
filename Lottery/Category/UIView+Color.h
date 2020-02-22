//
//  UIView+Color.h
//  Lottery
//
//  Created by wangjingming on 2020/1/2.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Color)
/**
 设置渐变色
 @params colors       渐变色数组
 @params startPoint 开始变化点 ( x:0-1 表示从左到右)
 @params endPoint  结束变化点 ( y:0-1 表示从上到下)
 */
- (void)setGradationColor:(NSArray <UIColor *> *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/**
 添加阴影并设置颜色
 @params color 阴影颜色
 */
- (void)setShadowAndColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
