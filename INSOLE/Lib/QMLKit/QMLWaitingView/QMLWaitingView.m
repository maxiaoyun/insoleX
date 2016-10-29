//
//  QMLWaitingView.m
//  testQMLKit
//
//  Created by Myron on 15/7/15.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLWaitingView.h"
#import "QMLShapeLayer.h"
@interface QMLWaitingView ()
{
    QMLShapeLayer *defaultLayer;
    CAGradientLayer *progressLayer;
    float span;
    NSTimer *timer;
}
@end
@implementation QMLWaitingView

-(void)setupDefineValues{
    [super setupDefineValues];
    span = 10;
}
-(void)setType:(QMLWaitingViewType )type{
    _type = type;
    [self createView];
}
-(void)createView{
    if (!defaultLayer) {
        [self createDefaultLayer];
    }
    if (!progressLayer) {
        progressLayer = [CAGradientLayer layer];
        progressLayer.colors = @[
                                 (id)[UIColor darkGrayColor].CGColor,
                                 (id)[UIColor greenColor].CGColor,
                                 (id)[UIColor darkGrayColor].CGColor
                                 ];
        progressLayer.startPoint = CGPointMake(-0.2, 0.5);
        progressLayer.endPoint = CGPointMake(0.0, 0.5);
        progressLayer.backgroundColor = [UIColor clearColor].CGColor;
        progressLayer.frame = self.bounds;
        [self.layer addSublayer:progressLayer];
        [CATransaction setAnimationDuration:1];
        [CATransaction commit];
    }
    progressLayer.mask = defaultLayer;
}
-(void)startAnimation:(BOOL)repeat{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(respondsToSelector:) object:@(repeat)];
    [CATransaction setAnimationDuration:0.5];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:@"linear"]];
    progressLayer.startPoint = CGPointMake(0.8, 0.5);
    progressLayer.endPoint = CGPointMake(1, 0.5);
    [CATransaction commit];
    [self performSelector:@selector(resetProgressLayer:) withObject:@(repeat) afterDelay:.6];
}
-(void)resetProgressLayer:(NSNumber*)repeat{
    [CATransaction setDisableActions:YES];
    progressLayer.startPoint = CGPointMake(-0.2, 0.5);
    progressLayer.endPoint = CGPointMake(0.0, 0.5);
    [CATransaction commit];
    if ([repeat boolValue]) {
        [self startAnimation:[repeat boolValue]];
    }
}
-(void)createDefaultLayer{
    defaultLayer = [QMLShapeLayer layer];
    defaultLayer.backgroundColor = [UIColor clearColor].CGColor;
    defaultLayer.frame = self.bounds;
    [self.layer addSublayer:defaultLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float h = self.bounds.size.height;
    
    CGPoint centerPoint[11]={
        CGPointMake(2*span, h/2),
        CGPointMake(3*span, h/2),
        CGPointMake(3.5*span, h/2+span),
        CGPointMake(4*span, h/2+span*2),
        CGPointMake(4.5*span, h/2+span),
        CGPointMake(5*span, h/2),
        CGPointMake(5.5*span, h/2-span),
        CGPointMake(6*span, h/2),
        CGPointMake(7*span, h/2),
        CGPointMake(8*span, h/2),
        CGPointMake(9*span, h/2),
    };
    [path moveToPoint:CGPointMake(span, h/2)];
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(span, h/2) radius:2 startAngle:0 endAngle:2*M_PI clockwise:YES]];
    for (int i=0; i<11; i++) {
        [path appendPath:[UIBezierPath bezierPathWithArcCenter:centerPoint[i] radius:2 startAngle:0 endAngle:2*M_PI clockwise:YES]];
    }
    defaultLayer.path = path.CGPath;
    defaultLayer.strokeColor = [UIColor darkGrayColor].CGColor;
    defaultLayer.lineWidth = 1;
    defaultLayer.lineCap = @"round";
    defaultLayer.fillColor = [UIColor darkGrayColor].CGColor;
    defaultLayer.backgroundColor = [UIColor clearColor].CGColor;
}
@end
