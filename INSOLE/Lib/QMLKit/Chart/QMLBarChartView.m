//
//  QMLBarChartView.m
//  testQMLKit
//
//  Created by Myron on 14/12/22.
//  Copyright (c) 2014年 Myron. All rights reserved.
//

#import "QMLBarChartView.h"
#import "QMLShapeLayer.h"
#import "QMLLog.h"

#define QMLBAR_VALUE_LAYER_FLAG_PREFIX @"QMLBarChartView_QMLShapeLayer_valueLayer"

@interface QMLBarChartView()
{
    QMLEdge edge;
    float minValue;
    float maxValue;
}
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *lineColor;
@property(nonatomic,assign)float lineWidth;
@property(nonatomic,assign)float level;

@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *barColor;
@property(nonatomic,assign)float barWidth;
@property(nonatomic,assign)float barSpan;


@end
@implementation QMLBarChartView
- (void)dealloc
{
    DEALLOC_PRINT;
#if __has_feature(objc_arc)
#else
    [_lineColor release];
    [_barColor release];
    [_values release];
    [super dealloc];
#endif
}
-(void)setValues:(NSArray *)values{
#if __has_feature(objc_arc)
    _values = values;
#else
    SET_PAR(_values,values);
#endif
    [self loadValueLayers:NO];
}
-(void)loadData:(NSArray *)data animation:(BOOL)animation
{
#if __has_feature(objc_arc)
    _values = data;
#else
    SET_PAR(_values,data);
#endif
    [self loadValueLayers:animation];
}
-(void)setupDefineValues{
    self.backgroundColor = [UIColor clearColor];
    [super setupDefineValues];
    edge.left = 20;
    edge.right =20;
    edge.top =20;
    edge.bottom =20;
    minValue = 0;
    maxValue = 1;
    _level = 10;
    self.lineColor = [UIColor lightGrayColor];
    self.lineWidth = 1;
    
    _barSpan = 5;
    _barWidth  = 15;
    self.barColor = COLOR_WITH_RGB(91, 186, 40);
}
-(void)removeValueLayers{
    for (QMLShapeLayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:[QMLShapeLayer class]]&&[layer.flag hasPrefix:QMLBAR_VALUE_LAYER_FLAG_PREFIX]) {
            [layer removeFromSuperlayer];
        }
    }
}
-(void)loadValueLayers:(BOOL)animation{
    [self removeValueLayers];
    NSUInteger valueCount = self.values.count;
    if (valueCount>0) {
        float h = self.bounds.size.height - edge.bottom - edge.top - 5;
        for (int i = 0; i<valueCount; i++) {
            float value = [[self.values objectAtIndex:i] floatValue]*h/(maxValue - minValue);
            float y = self.bounds.size.height - edge.bottom - value;
            QMLShapeLayer *valueLayer = [QMLShapeLayer layer];
            valueLayer.flag = [NSString stringWithFormat:@"%@_%d",QMLBAR_VALUE_LAYER_FLAG_PREFIX,i];
            valueLayer.frame = CGRectMake(self.barSpan*(i+1) + self.barWidth*i + edge.left, y, self.barWidth, value);
            [self.layer addSublayer:valueLayer];
            
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(valueLayer.bounds.size.width / 2, valueLayer.bounds.size.height)];
            [path addLineToPoint:CGPointMake(valueLayer.bounds.size.width/2, 0)];
            valueLayer.path = path.CGPath;
            valueLayer.strokeColor = self.barColor.CGColor;
            valueLayer.lineWidth = self.barWidth;
            
            if (animation) {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
                animation.fromValue = @0.0;
                animation.toValue = @1.0;
                animation.delegate = self;
                animation.duration = .5;
                [valueLayer addAnimation:animation forKey:@"lineAnimation"];
            }
        }
    }
}

- (void)drawRect:(CGRect)rect {
    float span = (rect.size.height - edge.bottom - edge.top - 5)/self.level;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextMoveToPoint(ctx, edge.left, edge.top);
    CGContextAddLineToPoint(ctx, edge.left, rect.size.height - edge.bottom);
    
    for (int i = 0; i<self.level+1; i++) {
        CGContextMoveToPoint(ctx, edge.left-2, rect.size.height - edge.bottom-span*i);
        CGContextAddLineToPoint(ctx, rect.size.width - edge.right, rect.size.height - edge.bottom-span*i);
    }
    CGContextDrawPath(ctx, kCGPathStroke);
    
    CGContextRestoreGState(ctx);
}
@end
