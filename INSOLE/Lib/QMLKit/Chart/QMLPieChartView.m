//
//  QMLPieChartView.m
//  testQMLKit
//
//  Created by Myron on 15/10/28.
//  Copyright © 2015年 Myron. All rights reserved.
//

#import "QMLPieChartView.h"
#import "QMLPieChartItem.h"
#import "QMLShapeLayer.h"
@interface QMLPieChartView()
{
    CAShapeLayer *cntLayer;
}
@end
@implementation QMLPieChartView

-(void)setupDefineValues{
    [super setupDefineValues];
    self.loopWidth = 20;
    self.padding = self.loopWidth/2;
    self.loopBgColor = [UIColor darkGrayColor];
}
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextSetStrokeColorWithColor(ctx, self.loopBgColor.CGColor);
    CGContextSetLineWidth(ctx, self.loopWidth);
    CGContextAddEllipseInRect(ctx, CGRectMake(self.padding, self.padding, rect.size.width-2*self.padding, rect.size.height-2*self.padding));
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
}

-(void)addPie:(NSArray *)items animationTime:(float)animationTime {
    
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(w/2, h/2) radius:(w-2*self.padding)/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    if (!cntLayer) {
        cntLayer = [CAShapeLayer layer];
        cntLayer.frame = self.bounds;
        cntLayer.fillColor = [UIColor clearColor].CGColor;
        cntLayer.strokeColor = [UIColor clearColor].CGColor;
        cntLayer.lineWidth  = self.loopWidth;
        cntLayer.path = [path CGPath];
        [self.layer addSublayer:cntLayer];
    }
    
    float sumValue = 0;
    for (int i=0; i<items.count; i++) {
        QMLPieChartItem *item = [items objectAtIndex:i];
        sumValue += item.value;
        QMLShapeLayer *layer = [QMLShapeLayer layer];
        layer.path = [path CGPath];
        layer.strokeColor = [item.pieColor CGColor];
        layer.lineWidth  = self.loopWidth;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeStart = 0;
        layer.strokeEnd = sumValue;
        [cntLayer insertSublayer:layer atIndex:0];
    }
    if (animationTime>0) {
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.fillColor = [UIColor clearColor].CGColor;
        maskLayer.strokeColor = [UIColor redColor].CGColor;
        maskLayer.lineWidth  = self.loopWidth;
        maskLayer.path = [path CGPath];
        maskLayer.strokeEnd = sumValue;
        cntLayer.mask = maskLayer;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
        animation.fromValue = @0.0;
        animation.toValue = @(sumValue);
        animation.duration = animationTime;
        [maskLayer addAnimation:animation forKey:@"maskLayerAnimation"];
    }
}
@end
