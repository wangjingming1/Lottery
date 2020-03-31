//
//  TrendChartLayer.m
//  Lottery
//
//  Created by wangjingming on 2020/3/25.
//  Copyright © 2020 wangjingming. All rights reserved.
//

#import "BonusTrendChartLayer.h"
#import "DrawUtils.h"

#import "GlobalDefines.h"
#import "BonusTrendChartModel.h"
#import "LotteryPracticalMethod.h"

@implementation BonusTrendChartLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showFootnote = YES;
        self.lineWidth = 1;
        self.footnoteHeight = 20;
        [self setContentsScale:[[UIScreen mainScreen] scale]];
    }
    return self;
}

- (void)calculateXArray:(CGFloat *)xArray yArray:(CGFloat *)yArray dataArray:(long long *)dataArray width:(CGFloat)width height:(CGFloat)height{
    long long minData = 1e14, maxData = -1e14;//±1亿亿,暂时精度够用
    NSInteger dateCount = self.model.trendChartDataModelArray.count;
    CGFloat singleWidth = width/dateCount;
    for (int i = 0; i < dateCount; i++) {
        long long data = [self.model.trendChartDataModelArray[i].data longLongValue];
        dataArray[i] = data;
        if (data < minData) minData = data;
        if (data > maxData) maxData = data;
    }
    
    CGFloat minY = 1/4.0*height;
    CGFloat contextY = height - minY*2;
    for (int i = 0; i < dateCount; i++) {
        long long data = *(dataArray + i);
        CGFloat y = 0;
        if (maxData != minData){
            y = minY + (maxData - data)*1.0/(maxData - minData)*contextY;//尴尬了,没有浮点数,这里乘上个1.0转一下
        }
        yArray[i] = y;
        
        CGFloat x = singleWidth/2 + singleWidth*i;
        xArray[i] = x;
    }
}

- (void)drawInContext:(CGContextRef)ctx{
    if (!self.model) return;
    if (!self.model.trendChartDataModelArray.count) return;
    NSInteger dateCount = self.model.trendChartDataModelArray.count;
    CGFloat footnoteHeight = self.footnoteHeight;
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = self.showFootnote ? CGRectGetHeight(self.bounds) - footnoteHeight : CGRectGetHeight(self.bounds);
    
    CGFloat xArray[dateCount];
    CGFloat yArray[dateCount];
    long long dataArray[dateCount];
    
    [self calculateXArray:xArray yArray:yArray dataArray:dataArray width:width height:height];
    
    drawAuxiliaryLine(ctx, CGPointMake(0, 0), CGPointMake(width, 0), self.lineWidth, kSubtitleTintTextColor.CGColor, NO, 0, NO);
    for (int i = 0; i < dateCount; i++){
        CGFloat x = xArray[i];
        drawAuxiliaryLine(ctx, CGPointMake(x, 0), CGPointMake(x, height), self.lineWidth, kSubtitleTintTextColor.CGColor, YES, 5, YES);
        if (self.showFootnote){
            BonusTrendChartDataModel *dataModel = self.model.trendChartDataModelArray[i];
            drawTextAtPoint(ctx, x, height + 5, DrawTextStyle_X_Left | DrawTextStyle_Y_Top, dataModel.footnote, 0, 12, kSubtitleTintTextColor);
        }
    }
    
    if (self.showFootnote && self.model.footnote){
        drawAuxiliaryLine(ctx, CGPointMake(0, height), CGPointMake(width, height), self.lineWidth, self.model.lineColor.CGColor, NO, 0, NO);
        drawTextAtPoint(ctx, 0, height + 5, DrawTextStyle_X_Left | DrawTextStyle_Y_Top, self.model.footnote, 0, 12, kSubtitleTintTextColor);
    }
    
    CGFloat radius = kPadding10/2;
    NSString *unit = self.model.trendChartDataModelArray.firstObject.unit;
    drawCircle(ctx, CGPointMake(radius, radius + kPadding10), radius, self.model.nodeColor.CGColor, self.model.nodeColor.CGColor, 0);
    drawTextAtPoint(ctx, radius*2 + kPadding10, radius + kPadding10, DrawTextStyle_X_Left | DrawTextStyle_Y_Center, self.model.title, 0, 12, self.model.titleColor);
    
    [self drawBonusTrendChartData:ctx xArray:xArray yArray:yArray bonusDataArray:dataArray unit:unit arrayCount:dateCount drawH:height radius:radius];
}

- (void)drawBonusTrendChartData:(CGContextRef)ctx xArray:(const CGFloat *)xArray yArray:(const CGFloat *)yArray bonusDataArray:(const long long *)dataArray unit:(NSString *)unit arrayCount:(NSInteger)arrayCount drawH:(CGFloat)drawH radius:(CGFloat)radius{
    [self drawGradationColor:ctx xArray:xArray yArray:yArray arrayCount:arrayCount drawH:drawH];
    for (NSInteger i = 0; i < arrayCount; i++){
        long long currentData = *(dataArray + i);
        CGFloat currentX = *(xArray + i);
        CGFloat currentY = yArray[i];
        if (i + 1 < arrayCount){
            CGFloat nextX = *(xArray + i + 1);
            CGFloat nextY = yArray[i + 1];
            drawAuxiliaryLine(ctx, CGPointMake(currentX, currentY), CGPointMake(nextX, nextY), self.lineWidth, self.model.lineColor.CGColor, NO, 0, NO);
        }
        drawCircle(ctx, CGPointMake(currentX, currentY), radius, self.model.nodeColor.CGColor, self.model.nodeColor.CGColor, 0);
        NSString *title = [NSString stringWithFormat:@"%@%@", [LotteryPracticalMethod getMaxUnitText:currentData withPrecisionNum:2], unit];
        drawTextAtPoint(ctx, currentX, currentY - radius, DrawTextStyle_X_Center | DrawTextStyle_Y_Bottom, title, 0, 12, self.model.titleColor);
    }
}

- (void)drawGradationColor:(CGContextRef)ctx xArray:(const CGFloat *)xArray yArray:(const CGFloat *)yArray arrayCount:(NSInteger)arratCount drawH:(CGFloat)drawH{
    if (arratCount == 0) return;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, xArray[0], yArray[0]);
    for (int i = 1; i < arratCount; i++){
        CGPathAddLineToPoint(path, NULL, xArray[i], yArray[i]);
    }
    CGPathAddLineToPoint(path, NULL, xArray[arratCount - 1], drawH);
    CGPathAddLineToPoint(path, NULL, xArray[0], drawH);
    CGPathCloseSubpath(path);
    
    UIColor *startColor = [self.model.nodeColor colorWithAlphaComponent:0.5];
    UIColor *endColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    //绘制渐变色
    drawGradationColor(ctx, path, @[startColor, endColor], startPoint, endPoint);
    
    //注意释放CGMutablePathRef
    CGPathRelease(path);
}
@end
