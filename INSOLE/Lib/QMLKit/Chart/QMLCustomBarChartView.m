//
//  QMLCustomBarChartView.m
//  testQMLKit
//
//  Created by Myron on 15/3/17.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLCustomBarChartView.h"
#import "QMLShapeLayer.h"
#define USE_SCROLL_VIEW
#define QMLCUSTOMBAR_VALUE_LAYER_FLAG_PREFIX @"QMLCustomBarChartView_QMLShapeLayer_valueLayer"

@interface QMLCustomBarChartView()
{
    UIScrollView *cntSc;
    float contentWidth;
    float lineViewHeight;
    float maxValue;
}
@end
@implementation QMLCustomBarChartView
- (void)dealloc
{
    DEALLOC_PRINT;
#if __has_feature(objc_arc)
#else
    [_lineColor release];
    [_data release];
    [_shadowColor release];
    [_scaleFont release];
    [_scaleColor release];
    [super dealloc];
#endif
}

-(void)setupDefineValues{
    [super setupDefineValues];
    _edge.left   = 25;
    _edge.right  = 20;
    _edge.top    = 20;
    _edge.bottom = 20;
    
    _levelScale = 10;
    _maxScale = 80;
    
    _level = 10;
    _barSpan = 5;
    _lineWidth = 1;
    self.lineColor = [UIColor lightGrayColor];
    self.scaleColor = [UIColor whiteColor];
    self.scaleFont = [UIFont systemFontOfSize:10];
    self.backgroundColor = [UIColor clearColor];
    [self redraw];
}

-(void)setEdge:(QMLEdge)edge{
    _edge.left   = edge.left;
    _edge.right  = edge.right;
    _edge.top    = edge.top;
    _edge.bottom = edge.bottom;
    
}
-(void)setData:(NSArray *)data{
    [self loadData:data animation:NO];
}
-(void)setLevel:(float)level{
    _level = level;
}
-(void)setLineWidth:(float)lineWidth{
    _lineWidth = lineWidth;
}
-(void)setLineColor:(UIColor *)lineColor{
    SET_PAR(_lineColor, lineColor);
}


-(float)loadData:(NSArray *)data animation:(BOOL)animation{
    SET_PAR(_data, data);
    float sumWidth =  [self loadValueLayers:animation];
    CGRect rect = self.frame;
    rect.size.width = sumWidth;
    self.frame = rect;
    [self redraw];
    return  sumWidth;
}
-(void)showLineWithHeight:(float)height lineColor:(UIColor *)lineColor animation:(BOOL)animation{
    [self showLineWithHeight:height lineColor:lineColor animation:animation span:1];
}
-(void)showLineWithHeight:(float)height lineColor:(UIColor *)lineColor animation:(BOOL)animation span:(int)span{
    [self showLineWithHeight:height lineColor:lineColor bgColor:[UIColor greenColor] animation:animation span:span];
}
-(void)showLineWithHeight:(float)height lineColor:(UIColor *)lineColor bgColor:(UIColor *)bgColor animation:(BOOL)animation span:(int)span{
    lineViewHeight = height;
    
    float h = self.bounds.size.height - _edge.bottom - _edge.top - 5;
    float y = self.bounds.size.height - _edge.bottom - maxValue*h - height;
    
    QMLShapeLayer *lineLayer = [QMLShapeLayer layer];
    QMLShapeLayer *lineBgLayer = [QMLShapeLayer layer];
    QMLShapeLayer *dotLayer = [QMLShapeLayer layer];
    QMLShapeLayer *dotLayer2 = [QMLShapeLayer layer];
    lineBgLayer.backgroundColor = [UIColor clearColor].CGColor;
    dotLayer.backgroundColor = [UIColor clearColor].CGColor;
    lineLayer.flag = [NSString stringWithFormat:@"%@_%u",QMLCUSTOMBAR_VALUE_LAYER_FLAG_PREFIX,(unsigned int)self.data.count+1];
    lineBgLayer.flag = [NSString stringWithFormat:@"%@_bg_%u",QMLCUSTOMBAR_VALUE_LAYER_FLAG_PREFIX,(unsigned int)self.data.count+1];
    dotLayer.flag = [NSString stringWithFormat:@"%@_dot_%u",QMLCUSTOMBAR_VALUE_LAYER_FLAG_PREFIX,(unsigned int)self.data.count+1];
    dotLayer2.flag = [NSString stringWithFormat:@"%@_dot2_%u",QMLCUSTOMBAR_VALUE_LAYER_FLAG_PREFIX,(unsigned int)self.data.count+1];
    
    dotLayer.opacity = 0;
    dotLayer2.opacity = 0;
    lineLayer.backgroundColor = [UIColor clearColor].CGColor; //[UIColor colorWithHue:1 saturation:0 brightness:0 alpha:.5].CGColor;
#ifdef USE_SCROLL_VIEW
    lineLayer.frame = CGRectMake(0, y, contentWidth, lineViewHeight);
    lineBgLayer.frame = CGRectMake(0, y, contentWidth, lineViewHeight);
    dotLayer.frame = CGRectMake(0, y, contentWidth, lineViewHeight);
    dotLayer2.frame = CGRectMake(0, y, contentWidth, lineViewHeight);
    
    
    [cntSc.layer addSublayer:lineBgLayer];
    [cntSc.layer addSublayer:lineLayer];
    [cntSc.layer addSublayer:dotLayer];
    [cntSc.layer addSublayer:dotLayer2];
#else
    lineLayer.frame = CGRectMake(_edge.left, 0, self.bounds.size.width-_edge.left-_edge.right, self.bounds.size.height);
    [self.layer addSublayer:lineLayer];
#endif
    
    
    NSUInteger valueCount = self.data.count;
    if (valueCount>0) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        UIBezierPath *dotPath = [UIBezierPath bezierPath];
        for (int i = 0; i<valueCount; i++) {
            QMLBarChartItem *item = [self.data objectAtIndex:i];
            float value = item.value*height;
            if (value>height) {
                continue;
            }
            
            float subY = height - value;
            float subX =  self.barSpan*(i+1) + item.barWidth*i + item.barWidth/2;
            
           
            
            if (i==0) {
                [path moveToPoint:CGPointMake(subX, subY)];
            }else{
                if (i%span == 0) {
                    [path addLineToPoint:CGPointMake(subX, subY)];
                    [dotPath moveToPoint:CGPointMake(subX, subY)];
                    [dotPath addLineToPoint:CGPointMake(subX, subY+.1)];
                }
            }
            if (i==valueCount-1) {
                
                [path addLineToPoint:CGPointMake(subX, subY)];
                [dotPath moveToPoint:CGPointMake(subX, subY)];
                [dotPath addLineToPoint:CGPointMake(subX, subY+.1)];
                
                UIBezierPath *tailPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(subX, subY) radius:2 startAngle:0 endAngle:M_PI*2 clockwise:0];
                [path appendPath:tailPath];
            }
        }
        
        
        lineLayer.path = path.CGPath;
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        lineLayer.strokeColor = [UIColor whiteColor].CGColor;
        lineLayer.lineCap = @"round";
        lineLayer.lineJoin = @"round";
        if (lineColor) {
            lineLayer.strokeColor = lineColor.CGColor;
        }
        lineLayer.lineWidth = 2;
        
        lineBgLayer.path = path.CGPath;
        lineBgLayer.fillColor = [UIColor clearColor].CGColor;
        lineBgLayer.strokeColor = bgColor.CGColor;
        lineBgLayer.lineCap = @"round";
        lineBgLayer.lineJoin = @"round";
        lineBgLayer.lineWidth = 5;
        lineBgLayer.shadowColor = bgColor.CGColor;
        
        lineBgLayer.shadowOpacity = 0.95;
        lineBgLayer.shadowOffset = CGSizeMake(0, 0);
        lineBgLayer.shadowRadius = M_PI;
        
        dotLayer.path = dotPath.CGPath;
        
        dotLayer.strokeColor = bgColor.CGColor;
        dotLayer.fillColor = [UIColor clearColor].CGColor;
        dotLayer.lineWidth = 10;
        dotLayer.lineCap = @"round";
        dotLayer.lineJoin = @"round";
        
        dotLayer.path = dotPath.CGPath;
        
        dotLayer2.strokeColor = lineColor.CGColor;
        dotLayer2.fillColor = [UIColor clearColor].CGColor;
        dotLayer2.lineWidth = 7;
        dotLayer2.lineCap = @"round";
        dotLayer2.lineJoin = @"round";
        dotLayer2.path = dotPath.CGPath;
        
        
        
        
        if (animation) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
            animation.fromValue = @0.0;
            animation.toValue = @1.0;
            animation.delegate = self;
            animation.duration = 1;
            [lineLayer addAnimation:animation forKey:@"lineAnimation"];
            [lineBgLayer addAnimation:animation forKey:@"lineAnimation"];
            
        }
        [self performSelector:@selector(showDotLayer:) withObject:dotLayer afterDelay:1];
        [self performSelector:@selector(showDotLayer:) withObject:dotLayer2 afterDelay:1];
    }
}
-(void)showDotLayer:(CALayer *)dotLayer{
    dotLayer.opacity = 1;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.delegate = self;
    animation.duration = 1;
    [dotLayer addAnimation:animation forKey:@"lineAnimation"];
}
-(void)showLineWithHeight:(float)height{
    [self showLineWithHeight:height lineColor:[UIColor whiteColor] animation:YES];
}
-(void)redraw{
    [self setNeedsDisplay];
}
-(void)removeValueLayers{
    
    NSMutableArray *arr = [NSMutableArray array];
#ifdef USE_SCROLL_VIEW
    [cntSc.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (QMLShapeLayer *layer in cntSc.layer.sublayers) {
#else
    for (QMLShapeLayer *layer in self.layer.sublayers) {
#endif
        if ([layer isKindOfClass:[QMLShapeLayer class]]&&[layer.flag hasPrefix:QMLCUSTOMBAR_VALUE_LAYER_FLAG_PREFIX]) {
            [arr addObject:layer];
        }
    }
    [arr makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}
-(float)loadValueLayers:(BOOL)animation{
    [self removeValueLayers];
    
#ifdef USE_SCROLL_VIEW
    if (!cntSc) {
        CGRect rect = CGRectMake(_edge.left, 0, self.bounds.size.width-_edge.left-_edge.right, self.bounds.size.height);
#if __has_feature(objc_arc)
        cntSc = [[UIScrollView alloc] initWithFrame:rect];
#else
        cntSc = [[[UIScrollView alloc] initWithFrame:rect] autorelease];
#endif
        [self addSubview:cntSc];
    }
#endif
    
    NSUInteger valueCount = self.data.count;
    float sumWidth = self.barSpan + _edge.left + _edge.right;
    maxValue = 0;
    if (valueCount>0) {
        float h = (self.bounds.size.height - _edge.bottom - _edge.top - 5)*self.maxScale/(self.level*self.levelScale);
        for (int i = 0; i<valueCount; i++) {
            QMLBarChartItem *item = [self.data objectAtIndex:i];
            float value = item.value*h;
            if (value>h) {
                continue;
            }
            maxValue = maxValue>item.value?maxValue:item.value;
            
            float y = self.bounds.size.height - _edge.bottom - value;
#if __has_feature(objc_arc)
            UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, item.barWidth, item.barWidth)];
#else
            UILabel *la = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, item.barWidth, item.barWidth)] autorelease];
#endif
            la.adjustsFontSizeToFitWidth = YES;
            la.textAlignment = NSTextAlignmentCenter;
            la.text = item.title;
            la.backgroundColor =[UIColor clearColor];
            la.textColor = item.titleColor;
            la.font = item.titleFont;
            la.frame = CGRectMake(self.barSpan*(i+1) + item.barWidth*i, self.bounds.size.height - _edge.bottom, item.barWidth, item.barWidth);
            [cntSc addSubview:la];
            
            QMLShapeLayer *valueLayer = [QMLShapeLayer layer];
            valueLayer.flag = [NSString stringWithFormat:@"%@_%d",QMLCUSTOMBAR_VALUE_LAYER_FLAG_PREFIX,i];
            valueLayer.frame = CGRectMake(self.barSpan*(i+1) + item.barWidth*i + _edge.left, y, item.barWidth, value);
            
            if (self.shadowColor) {
                valueLayer.shadowOpacity = .75;
                valueLayer.shadowOffset = CGSizeMake(2, -1);
                valueLayer.shadowColor = self.shadowColor.CGColor;
            }
#ifdef USE_SCROLL_VIEW
            valueLayer.frame = CGRectMake(self.barSpan*(i+1) + item.barWidth*i, y, item.barWidth, value);
            [cntSc.layer addSublayer:valueLayer];
#else
            valueLayer.frame = CGRectMake(self.barSpan*(i+1) + item.barWidth*i + _edge.left, y, item.barWidth, value);
            [self.layer addSublayer:valueLayer];
#endif
            
            
            
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(valueLayer.bounds.size.width / 2, valueLayer.bounds.size.height)];
            [path addLineToPoint:CGPointMake(valueLayer.bounds.size.width/2, 0)];
            valueLayer.path = path.CGPath;
            valueLayer.strokeColor = item.barColor.CGColor;
            valueLayer.lineWidth = item.barWidth;
            
            if (animation) {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
                animation.fromValue = @0.0;
                animation.toValue = @1.0;
                animation.delegate = self;
                animation.duration = .5;
                [valueLayer addAnimation:animation forKey:@"lineAnimation"];
            }
            
            sumWidth += self.barSpan+item.barWidth;
        }
    }
    contentWidth = sumWidth;
#ifdef USE_SCROLL_VIEW
    if (sumWidth>cntSc.contentSize.width) {
        cntSc.contentSize = CGSizeMake(sumWidth, cntSc.contentSize.height);
    }else{
        cntSc.contentSize = CGSizeMake(cntSc.contentSize.width, cntSc.contentSize.height);
    }
    return self.frame.size.width;
#else
    return sumWidth;
#endif
}


-(void)drawRect:(CGRect)rect{
    float span = (rect.size.height - _edge.bottom - _edge.top - 5)/self.level;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextMoveToPoint(ctx, _edge.left, _edge.top);
    CGContextAddLineToPoint(ctx, _edge.left, rect.size.height -  _edge.bottom);
    

    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentRight;

    float x = _edge.left-2;
    for (int i = 0; i<self.level+1; i++) {
        float b_y = rect.size.height  - _edge.bottom  - span*i;

        if (self.showLevelLine||i==0) {
            CGContextMoveToPoint(ctx, x, b_y);
            CGContextAddLineToPoint(ctx, rect.size.width - _edge.right, b_y);
        }
        
        CGContextSaveGState(ctx);
        CGRect scaleRect = CGRectMake(x-23, b_y - 7, 20, 15);
        NSString *scaleStr = [NSString stringWithFormat:@"%d",self.levelScale*i];
        [scaleStr drawInRect:scaleRect withAttributes:@{
                                                       NSFontAttributeName:self.scaleFont,
                                                       NSForegroundColorAttributeName:self.scaleColor,
                                                       NSParagraphStyleAttributeName:paragraphStyle
                                                       }];
        CGContextRestoreGState(ctx);
    }
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
}
@end
