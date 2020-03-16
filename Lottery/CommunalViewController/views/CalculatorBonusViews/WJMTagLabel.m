//
//  WJMTagLabel.m
//  Lottery
//
//  Created by wangjingming on 2020/3/10.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "WJMTagLabel.h"

@interface WJMTagLabel()
@property (nonatomic, strong) UIBezierPath *tagPath;
@end

@implementation WJMTagLabel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.triangleSide = 4;
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];

    
    /*
        1.5PI
    00PI     0PI
        0.5PI
     */
    CGRect frame = self.bounds;
    CGFloat w = CGRectGetWidth(frame);
    CGFloat h = CGRectGetHeight(frame) - self.triangleSide;
    CGFloat cornerRadius = h/5;
    
    UIBezierPath *tagPath = [UIBezierPath new];
    [tagPath moveToPoint:CGPointMake(cornerRadius, 0)];
    [tagPath addLineToPoint:CGPointMake(w - cornerRadius, 0)];
    [tagPath addArcWithCenter:CGPointMake(w - cornerRadius, cornerRadius) radius:cornerRadius startAngle:1.5*M_PI endAngle:0 clockwise:YES];
    [tagPath addLineToPoint:CGPointMake(w, h - cornerRadius)];
    [tagPath addArcWithCenter:CGPointMake(w - cornerRadius, h - cornerRadius) radius:cornerRadius startAngle:0 endAngle:0.5*M_PI clockwise:YES];
    
    [tagPath addLineToPoint:CGPointMake(w/2 + self.triangleSide, h)];
    [tagPath addLineToPoint:CGPointMake(w/2, h+self.triangleSide)];
    [tagPath addLineToPoint:CGPointMake(w/2 - self.triangleSide, h)];
    
    [tagPath addLineToPoint:CGPointMake(cornerRadius, h)];
    [tagPath addArcWithCenter:CGPointMake(cornerRadius, h - cornerRadius) radius:cornerRadius startAngle:0.5*M_PI endAngle:M_PI clockwise:YES];
    [tagPath addLineToPoint:CGPointMake(0, cornerRadius)];
    [tagPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius) radius:cornerRadius startAngle:M_PI endAngle:1.5*M_PI clockwise:YES];
    
    [tagPath stroke];
    [tagPath fill];
    [tagPath closePath];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = frame;
    layer.path = tagPath.CGPath;
    layer.fillColor = [UIColor redColor].CGColor;
    self.layer.mask = layer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawTextInRect:(CGRect)rect{
    rect.size.height = rect.size.height - self.triangleSide;
    [super drawTextInRect:rect];
}
@end
