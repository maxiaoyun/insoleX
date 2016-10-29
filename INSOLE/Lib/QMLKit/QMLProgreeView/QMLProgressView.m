//
//  QMLProgressView.m
//  testQMLKit
//
//  Created by Myron on 14/12/30.
//  Copyright (c) 2014年 Myron. All rights reserved.
//

#import "QMLProgressView.h"
#import "QMLLayoutFunction.h"
#import "QMLLog.h"

@interface QMLProgressView()
{
    CAShapeLayer *proLayer;
    CAShapeLayer *bgLayer;
}
@end

@implementation QMLProgressView
- (void)dealloc
{
    DEALLOC_PRINT;
#if __has_feature(objc_arc)
#else
    Block_release(_progressChanged);
    [_defaultColor release];
    [_progressColor release];
    [super dealloc];
#endif
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self setupDefineValues];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupDefineValues];
}
-(void)setupDefineValues
{
    [super setupDefineValues];
    _type=QMLProgressViewRound;
    _borderType=QMLProgressViewBorderTypeDoubleRound;
    _progressWidth=10;
    UIColor *d_color=COLOR_WITH_RGB(153, 153, 153);
    UIColor *color=[UIColor whiteColor];
    self.defaultColor = d_color;
    self.progressColor = color;
    [self setNeedsDisplay];
}

-(UIBezierPath*)path{
    switch (self.type) {
        case QMLProgressViewPath: return _path;
        case QMLProgressViewRound:
        {
            float w = self.frame.size.width;
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.progressWidth/2, self.progressWidth/2, w - self.progressWidth, w - self.progressWidth) cornerRadius:w/2];
            return path;
        }
            break;
            
        default: ;
    }
    return nil;
}
-(void)setProgress:(float)progress
{
    _progress=progress<0?0:(progress>1?1:progress);
    if (_progressChanged) {
        _progressChanged();
    }
    switch (self.type) {
        case QMLProgressViewPath:
        case QMLProgressViewRound:
            if (!proLayer) {
                
                bgLayer = [CAShapeLayer layer];
                bgLayer.frame = self.bounds;
                bgLayer.fillColor = [UIColor clearColor].CGColor;
                bgLayer.path = self.path.CGPath;
                [self.layer addSublayer:bgLayer];
                if (self.borderType == QMLProgressViewBorderTypeDoubleRound) {
                    bgLayer.lineCap = @"round";
                }
                bgLayer.strokeEnd = 1;
                
                proLayer = [CAShapeLayer layer];
                proLayer.frame = self.bounds;
                proLayer.fillColor = [UIColor clearColor].CGColor;
                proLayer.path = self.path.CGPath;
                [self.layer addSublayer:proLayer];
                if (self.borderType == QMLProgressViewBorderTypeDoubleRound) {
                    proLayer.lineCap = @"round";
                }
                
            }
            bgLayer.strokeColor = self.defaultColor.CGColor;
            bgLayer.lineWidth = self.progressWidth;
            
            proLayer.lineWidth = self.progressWidth;
            proLayer.strokeColor = self.progressColor.CGColor;
            proLayer.strokeEnd = self.progress;
            break;
        default:
            [self setNeedsDisplay];
            break;
    }
}
-(void)drawDefaultProgress:(CGContextRef)ctx rect:(CGRect)rect
{
    CGContextSaveGState(ctx);
    CGContextSetFillColorWithColor(ctx, self.defaultColor.CGColor);
    CGContextFillRect(ctx, rect);
    CGContextRestoreGState(ctx);
    
    float pro=self.progress*rect.size.width;
    CGContextSaveGState(ctx);
    CGContextSetFillColorWithColor(ctx, self.progressColor.CGColor);
    switch (self.borderType) {
        case QMLProgressViewBorderTypeRound:
        {
            CGContextMoveToPoint(ctx, 0, 0);
            float radius=rect.size.height/2;
            CGContextAddLineToPoint(ctx, pro-radius,0);
            CGContextAddArc(ctx, pro-radius, radius, radius, -M_PI/2, M_PI/2, 0);
            CGContextAddLineToPoint(ctx, 0, rect.size.height);
            CGContextAddLineToPoint(ctx, 0, 0);
        }
            break;
        case QMLProgressViewBorderTypePlain:
            CGContextMoveToPoint(ctx, 0, 0);
            CGContextAddLineToPoint(ctx, pro, 0);
            CGContextAddLineToPoint(ctx, pro, rect.size.height);
            CGContextAddLineToPoint(ctx, 0, rect.size.height);
            CGContextAddLineToPoint(ctx, 0, 0);
            break;
        case QMLProgressViewBorderTypeDoubleRound:
        {
            float radius=rect.size.height/2;
            CGContextMoveToPoint(ctx, radius, 0);
            CGContextAddLineToPoint(ctx, pro-radius,0);
            CGContextAddArc(ctx, pro-radius, radius, radius, -M_PI/2, M_PI/2, 0);
            CGContextAddLineToPoint(ctx, radius, rect.size.height);
            CGContextAddArc(ctx, radius, radius, radius,M_PI/2, -M_PI/2, 0);
        }
            break;
    }
    CGContextFillPath(ctx);
    CGContextRestoreGState(ctx);
}
-(void)drawPieProgress:(CGContextRef)ctx rect:(CGRect)rect
{
    float width=rect.size.width;
    float height=rect.size.height;
    float radius=width>height?(height/2):(width/2);
    CGContextSaveGState(ctx);
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, radius*2, radius*2));
    CGContextSetFillColorWithColor(ctx, self.defaultColor.CGColor);
    CGContextFillPath(ctx);
    CGContextRestoreGState(ctx);
    
    float endAngle=self.progress*2*M_PI;
    CGContextSaveGState(ctx);
    CGContextMoveToPoint(ctx, radius, radius);
    CGContextAddLineToPoint(ctx, radius+radius, radius);
    CGContextAddArc(ctx, radius, radius, radius, 0, endAngle, 0);
    CGContextAddLineToPoint(ctx, radius, radius);
    CGContextSetFillColorWithColor(ctx, self.progressColor.CGColor);
    CGContextFillPath(ctx);
    CGContextRestoreGState(ctx);
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    switch (self.type) {
        case QMLProgressViewDefault:
            [self drawDefaultProgress:ctx rect:rect];
            break;
        case QMLProgressViewPie:
            [self drawPieProgress:ctx rect:rect];
            break;
        default:
            break;
    }
    UIGraphicsPopContext();
}
@end
