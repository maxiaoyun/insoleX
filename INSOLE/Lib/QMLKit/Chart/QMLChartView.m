//
//  QMLChartView.m
//  testQMLKit
//
//  Created by Myron on 15/10/27.
//  Copyright © 2015年 Myron. All rights reserved.
//

#import "QMLChartView.h"
#import "QMLShapeLayer.h"
#import "QMLBarChartItem.h"
#import "QMLLineChartItem.h"
#import "QMLShapeView.h"

@interface QMLChartView ()
{
    QMLCharViewInfoStruct infoStruct;
    UIScrollView *cntSc;
    int shapeCnt;
    NSMutableDictionary *pointDict;
}
@end
@implementation QMLChartView
-(void)setupDefineValues{
    [super setupDefineValues];
    infoStruct.dashLine       = YES;
    infoStruct.showXAxis      = YES;
    infoStruct.showYAxis      = YES;
    infoStruct.showLine       = YES;
    infoStruct.showLineTitle  = YES;
    infoStruct.showXAxisLine  = YES;
    infoStruct.showXAxisTitle = YES;
    infoStruct.showLastLine   = YES;
    self.widthForLineTitle = 30;
    self.spanForTitle = 5;
    self.axisLineWidth = 1;
    self.axisLineColor = [UIColor whiteColor];
    self.bottom = 30;
    self.top = 30;
    self.contentXOffset = 0;
    self.contentYOffset = 10;
    
    self.xAxisCnt = 10;
    self.xAxisSpan = 30;
    self.xAxisTitleStep = 4;
    
    self.lineCnt = 3;
    self.lineSpan = 50;
    self.lineWidth = 1;
    self.lineColor = [UIColor whiteColor];
    pointDict = [NSMutableDictionary dictionary];
}
-(void)drawRect:(CGRect)rect{
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (infoStruct.showYAxis||infoStruct.showXAxis) {
        CGContextSaveGState(ctx);
        CGContextSetLineWidth(ctx, self.axisLineWidth);
        CGContextSetStrokeColorWithColor(ctx, self.axisLineColor.CGColor);
        CGContextMoveToPoint(ctx, self.widthForLineTitle+self.spanForTitle, h-self.bottom);
        if (infoStruct.showXAxis) {
            CGContextAddLineToPoint(ctx, w, h-self.bottom);
        }
        if (infoStruct.showYAxis) {
            CGContextMoveToPoint(ctx, self.widthForLineTitle+self.spanForTitle, h-self.bottom);
            CGContextAddLineToPoint(ctx, self.widthForLineTitle+self.spanForTitle, self.top);
        }
        CGContextDrawPath(ctx, kCGPathStroke);
        CGContextRestoreGState(ctx);
    }
    
    
    CGContextSaveGState(ctx);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    for (int i=0; i<self.lineCnt; i++) {
        CGPoint endPoint = CGPointMake( w, h - self.bottom - self.lineSpan*i);
        
        CGContextSaveGState(ctx);
        if (infoStruct.showLineTitle) {
            NSString *title = nil;
            UIFont *titleFont = [UIFont systemFontOfSize:12];
            if (self.lineTitleInfo) {
                self.lineTitleInfo(i,&title,&titleFont);
            }
            if (title) {
                CGRect rect = CGRectMake(0, endPoint.y - titleFont.lineHeight/2, self.widthForLineTitle, titleFont.lineHeight);
                NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                paragraphStyle.alignment = NSTextAlignmentRight;
                [title drawInRect:rect withAttributes:@{NSFontAttributeName:titleFont,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:self.lineColor}];
                
            }
        }
        CGContextRestoreGState(ctx);
        if (i==0) {
            continue;
        }
        
        if (infoStruct.showLine) {
            if (i==self.lineCnt-1&&!infoStruct.showLastLine) {
                
            }else{
                CGContextMoveToPoint(ctx, self.widthForLineTitle+self.spanForTitle, h - self.bottom - self.lineSpan*i);
                if (infoStruct.dashLine) {
                    CGFloat lineLen  = 5;
                    CGFloat whiteLen = 2;
                    if (self.dashInfo) {
                        self.dashInfo(&lineLen,&whiteLen);
                    }
                    const CGFloat lengths[] = {lineLen,whiteLen};
                    CGContextSetLineDash(ctx, 0,lengths , 2);
                }
                CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y);
            }
        }
    }
    for (int i=0; i<self.xAxisCnt; i++) {
        
        CGPoint beginPoint = CGPointMake(self.widthForLineTitle+self.spanForTitle + self.xAxisSpan*i, h - self.bottom);
        
        CGContextSaveGState(ctx);
        if (infoStruct.showXAxisTitle&&self.xAxisTitleStep!=0&&i%self.xAxisTitleStep==0) {
            NSString *title = nil;
            UIFont *titleFont = [UIFont systemFontOfSize:12];
            if (self.xAxisTitleInfo) {
                self.xAxisTitleInfo(i,&title,&titleFont);
            }
            if (title) {
                float t_w = self.xAxisTitleStep*self.xAxisSpan;
                CGRect rect = CGRectMake(beginPoint.x - t_w/2, h - self.bottom + self.spanForTitle, t_w, titleFont.lineHeight);
                NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                paragraphStyle.alignment = NSTextAlignmentCenter;
                [title drawInRect:rect withAttributes:@{NSFontAttributeName:titleFont,NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:self.lineColor}];
                
            }
        }
        CGContextRestoreGState(ctx);
        
        if (i==0) {
            continue;
        }
        
        if (infoStruct.showXAxisLine) {
            CGContextMoveToPoint(ctx, beginPoint.x, beginPoint.y);
            CGContextAddLineToPoint(ctx, self.widthForLineTitle+self.spanForTitle + self.xAxisSpan*i, self.top);
        }
    }
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
}
-(QMLCharViewInfoStructRef)info{
    return &infoStruct;
}
-(QMLShapeLayer *)shapeLayerWithFlag:(NSString *)flag{
    if ([flag isKindOfClass:[NSString class]]) {
        for (QMLShapeLayer *layer in cntSc.layer.sublayers) {
            if ([layer isKindOfClass:[QMLShapeLayer class]]&&[flag isEqualToString:layer.flag]) {
                return layer;
            }
        }
    }
    return nil;
}
-(NSString *)addLine:(NSArray *)values color:(UIColor *)color lineWidth:(float)width dotRadius:(float)dotRadius animationTime:(float)animationTime {
    
    float yOffset = self.contentYOffset;
    float w   = self.frame.size.width - self.spanForTitle - self.widthForLineTitle;
    float v_h = (self.lineCnt-1)*self.lineSpan-self.axisLineWidth;
    float h   = v_h+self.bottom+yOffset;
    float x   = self.widthForLineTitle+self.spanForTitle;
    float y   = self.frame.size.height-h;
    
    if (!cntSc) {
        cntSc = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        cntSc.showsHorizontalScrollIndicator = NO;
        cntSc.showsVerticalScrollIndicator = NO;
        [self addSubview:cntSc];
    }
    
    QMLShapeView *shapeView = [[QMLShapeView alloc] initWithFrame:CGRectMake(self.contentXOffset, 0, cntSc.frame.size.width, cntSc.frame.size.height)];
    [cntSc  addSubview:shapeView];
    
    shapeCnt ++;
    
    shapeView.flag = [NSString stringWithFormat:@"QMLChartView_line_chart_%d",shapeCnt];
    shapeView.tag = shapeCnt;
    
    int itemCnt = (int)values.count;
    __weak typeof(self)bSelf = self;
    __weak typeof(shapeView)bShapeView = shapeView;
    shapeView.touchEvent = ^(NSSet<UITouch *> *touches,UIEvent *event,QMLTouchEventType type){
        [bSelf touchesHandle:touches itemCnt:itemCnt inView:bShapeView eventType:type];
    };
    
    
    CAShapeLayer * shapeLayer = (QMLShapeLayer *)shapeView.layer;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.lineWidth = width;
    


    
    
    NSMutableArray *points = [NSMutableArray array];
    if (values.count>0) {
        
        QMLShapeLayer *dotLayer = [QMLShapeLayer layer];
        dotLayer.frame = shapeLayer.bounds;
        [shapeLayer addSublayer:dotLayer];
        dotLayer.fillColor   = color.CGColor;
        dotLayer.strokeColor = color.CGColor;
        dotLayer.lineWidth = width;
        dotLayer.flag = @"QMLChartView_dot_shape_layer";

        
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        UIBezierPath *dotPath  = [UIBezierPath bezierPath];
        for (int i=0; i<values.count-1; i++) {
            id obj = [values objectAtIndex:i];
            float y_v = v_h - [obj floatValue]*v_h + yOffset;
            float x_v = self.xAxisSpan*(i+1);
            CGPoint f_point = CGPointMake(x_v, y_v);
            [points addObject:[NSValue valueWithCGPoint:f_point]];
            
            [linePath moveToPoint:f_point];
            float s_x = self.xAxisSpan*(i+2);
            float s_y = v_h - [[values objectAtIndex:i+1] floatValue]*v_h + yOffset;
            [linePath addCurveToPoint:CGPointMake(s_x, s_y) controlPoint1:CGPointMake((s_x-x_v)/2+x_v, y_v) controlPoint2:CGPointMake((s_x-x_v)/2+x_v, s_y)];
            [dotPath appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.xAxisSpan*(i+1), y_v) radius:dotRadius startAngle:0 endAngle:2*M_PI clockwise:YES]];
        }
        shapeLayer.path = [linePath CGPath];
        id obj = [values lastObject];
        float y_v = v_h - [obj floatValue]*v_h + yOffset;
        float x_v = self.xAxisSpan*values.count;
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(x_v, y_v)]];
        
        [dotPath appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(x_v, y_v) radius:dotRadius startAngle:0 endAngle:2*M_PI clockwise:YES]];
        dotLayer.path   = [dotPath CGPath];
        
        
        shapeLayer.masksToBounds = YES;
        
        
        [pointDict setObject:points forKey:@(shapeCnt)];
        
        
        float c_w = (values.count+1)*self.xAxisSpan-self.contentXOffset;
        
        CGRect rect = shapeLayer.frame;
        rect.size.width = c_w;
        shapeLayer.frame = rect;
        
        CGRect dotRect = dotLayer.frame;
        dotRect.size.width = c_w;
        dotLayer.frame = dotRect;
        
        if (animationTime>0) {
            [shapeLayer addAnimation:[self lineAnimation:animationTime] forKey:@"lineAnimation"];
        }
        
        if (c_w>cntSc.contentSize.width) {
            [cntSc setContentSize:CGSizeMake(c_w, cntSc.contentSize.height)];
        }
    }
    
    return @"";
}
-(CAAnimationGroup*)lineAnimation:(float)animationTime{
    float w = cntSc.bounds.size.width;
    float h = cntSc.bounds.size.height;
    float x = self.contentXOffset;
    float y = 0;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    
    CABasicAnimation *positionAni = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAni.fromValue =[NSValue valueWithCGPoint:CGPointMake(x, y+h/2)];
    positionAni.toValue = [NSValue valueWithCGPoint:CGPointMake(w/2+x, y+h/2)];
    
    CABasicAnimation *boundsAni = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAni.fromValue =[NSValue valueWithCGRect:CGRectMake(0, 0, 0, h)];
    boundsAni.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, w, h)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[positionAni,boundsAni];
    group.duration = animationTime;
    return group;
}

-(NSString *)addBar:(NSArray *)items cornerRadius:(float)cornerRadius animationTime:(float)animationTime {
    
    float w   = self.frame.size.width - self.spanForTitle - self.widthForLineTitle;
    float v_h = (self.lineCnt-1)*self.lineSpan-self.axisLineWidth;
    float h   = v_h+self.bottom+self.contentYOffset;
    float x   = self.widthForLineTitle+self.spanForTitle;
    float y   = self.frame.size.height-h;
    if (!cntSc) {
        cntSc = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        cntSc.showsHorizontalScrollIndicator = NO;
        cntSc.showsVerticalScrollIndicator = NO;
        [self addSubview:cntSc];
    }

    for (int i=0; i<items.count; i++) {
        QMLBarChartItem *item = [items objectAtIndex:i];
        float i_h = item.value*v_h;
        float i_y = h - self.bottom - i_h - self.axisLineWidth/2 ;
        float i_x = self.xAxisSpan + self.xAxisSpan*i;
        CGRect rect = CGRectMake(i_x-item.barWidth/2, i_y, item.barWidth, i_h);
        QMLShapeLayer *layer = [QMLShapeLayer layer];
        layer.frame = rect;
        layer.cornerRadius = cornerRadius;
        layer.backgroundColor = item.barColor.CGColor;
        [cntSc.layer addSublayer:layer];
        
        if (animationTime>0) {
            CABasicAnimation *boundsAni = [CABasicAnimation animationWithKeyPath:@"bounds"];
            boundsAni.fromValue =[NSValue valueWithCGRect:CGRectMake(i_x-item.barWidth/2, i_y-i_h, item.barWidth, 0)];
            boundsAni.toValue = [NSValue valueWithCGRect:CGRectMake(i_x-item.barWidth/2, i_y, item.barWidth, i_h)];
            boundsAni.duration = animationTime;
            [layer addAnimation:boundsAni forKey:@"barAnimation"];
        }
        
        if (item.title&&i%self.xAxisTitleStep==0) {
            UIFont *font = item.titleFont;
            float t_w = self.xAxisTitleStep*self.xAxisSpan;
            CGRect rect = CGRectMake(i_x - t_w/2, h - self.bottom + self.spanForTitle, t_w, font.lineHeight);
            UILabel *la = [[UILabel alloc] initWithFrame:rect];
            la.text = item.title;
            la.textColor = item.titleColor;
            la.font = item.titleFont;
            la.textAlignment = NSTextAlignmentCenter;
            la.backgroundColor = [UIColor clearColor];
            [cntSc addSubview:la];
        }
    }
    [cntSc setContentSize:CGSizeMake((items.count+1)*self.xAxisSpan, cntSc.contentSize.height)];
    return nil;
}
-(void)touchesHandle:(NSSet<UITouch *> *)touches itemCnt:(int)itemCnt inView:(QMLShapeView *)shapeView eventType:(QMLTouchEventType)type
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:shapeView];
    
    int index = (int)round(point.x/self.xAxisSpan)-1;
    index = index>0?index:0;
    index = (index>itemCnt-1)?(itemCnt-1):index;
    NSMutableArray *points = [NSMutableArray array];
    for (NSArray *arr in pointDict.allValues) {
        if (index<arr.count) {
            [points addObject:[arr objectAtIndex:index]];
        }
    }
    QMLog(@"touchBegin:  index:%d type:%d points:%@",index,type,points);
    if (self.touchWithXAxis) {
        self.touchWithXAxis(index,points,type,shapeView);
    }
}
-(NSString *)addLineWithItems:(NSArray *)items lineColor:(UIColor *)lineColor lineWidth:(float)width dotRadius:(float)dotRadius animationTime:(float)animationTime{
    
    float yOffset = self.contentYOffset;
    float w   = self.frame.size.width - self.spanForTitle - self.widthForLineTitle;
    float v_h = (self.lineCnt-1)*self.lineSpan-self.axisLineWidth;
    float h   = v_h+self.bottom+yOffset;
    float x   = self.widthForLineTitle+self.spanForTitle;
    float y   = self.frame.size.height-h;
    
    if (!cntSc) {
        cntSc = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        cntSc.showsHorizontalScrollIndicator = NO;
        cntSc.showsVerticalScrollIndicator = NO;
        [self addSubview:cntSc];
    }
    
    QMLShapeView *shapeView = [[QMLShapeView alloc] initWithFrame:CGRectMake(self.contentXOffset, 0, cntSc.frame.size.width, cntSc.frame.size.height)];
    [cntSc  addSubview:shapeView];
    
    shapeCnt ++;
    
    shapeView.flag = [NSString stringWithFormat:@"QMLChartView_line_chart_%d",shapeCnt];
    shapeView.tag = shapeCnt;
    
    
    int itemCnt = (int)items.count;
    __weak typeof(self)bSelf = self;
    __weak typeof(shapeView)bShapeView = shapeView;
    shapeView.touchEvent = ^(NSSet<UITouch *> *touches,UIEvent *event,QMLTouchEventType type){
        [bSelf touchesHandle:touches itemCnt:itemCnt inView:bShapeView eventType:type];
    };
    
    
    CAShapeLayer * shapeLayer = (QMLShapeLayer *)shapeView.layer;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = lineColor.CGColor;
    shapeLayer.lineWidth = width;
    
    NSMutableArray *points = [NSMutableArray array];
    QMLShapeLayer *dotLayer = [QMLShapeLayer layer];
    if (items.count>0) {
        dotLayer.frame = shapeLayer.bounds;
        [shapeLayer addSublayer:dotLayer];
        dotLayer.fillColor   = lineColor.CGColor;
        dotLayer.strokeColor = lineColor.CGColor;
        dotLayer.lineWidth = width;
        dotLayer.flag = @"QMLChartView_dot_shape_layer";
        
        
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        UIBezierPath *dotPath  = [UIBezierPath bezierPath];
        
       
        for (int i=0; i<items.count-1; i++) {
            QMLLineChartItem *lineChartItem = [items objectAtIndex:i];
            float v = lineChartItem.value;
            float y_v = v_h - v*v_h + yOffset;
            float x_v = self.xAxisSpan*(i+1);
            
            CGPoint f_point = CGPointMake(x_v, y_v);
            [points addObject:[NSValue valueWithCGPoint:f_point]];
            
            [linePath moveToPoint:f_point];
            QMLLineChartItem *s_item = [items objectAtIndex:i+1];
            float s_x = self.xAxisSpan*(i+2);
            float s_y = v_h - s_item.value*v_h + yOffset;
            
            [linePath addCurveToPoint:CGPointMake(s_x, s_y) controlPoint1:CGPointMake((s_x-x_v)/2+x_v, y_v) controlPoint2:CGPointMake((s_x-x_v)/2+x_v, s_y)];
            if (!lineChartItem.keyPoint) {
                [dotPath appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.xAxisSpan*(i+1), y_v) radius:lineChartItem.dotRadius startAngle:0 endAngle:2*M_PI clockwise:YES]];
            }else{
                CALayer *layer = [CALayer layer];
                layer.frame = CGRectMake(0, 0, lineChartItem.dotRadius*2, lineChartItem.dotRadius*2);
                layer.cornerRadius = lineChartItem.dotRadius;
                layer.backgroundColor = lineChartItem.keyColor.CGColor;
                layer.position = CGPointMake(x_v, y_v);
                [shapeLayer addSublayer:layer];
                
                UILabel *infoLa = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 15)];
                infoLa.attributedText = lineChartItem.valueStr;
                CGSize size = [infoLa sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
                infoLa.frame = CGRectMake(x_v-size.width/2, y_v-lineChartItem.dotRadius-4-size.height, size.width, size.height);
                [shapeView addSubview:infoLa];
            }
            
            if (lineChartItem.title&&i%self.xAxisTitleStep==0) {
                UIFont *font = lineChartItem.titleFont;
                float t_w = self.xAxisTitleStep*self.xAxisSpan;
                CGRect rect = CGRectMake(x_v - t_w/2, h - self.bottom + self.spanForTitle, t_w, font.lineHeight);
                UILabel *la = [[UILabel alloc] initWithFrame:rect];
                la.text = lineChartItem.title;
                la.textColor = lineChartItem.titleColor;
                la.font = lineChartItem.titleFont;
                la.textAlignment = NSTextAlignmentCenter;
                la.backgroundColor = [UIColor clearColor];
                [shapeView addSubview:la];
            }
        }
        shapeLayer.path = [linePath CGPath];
        QMLLineChartItem * lastItem = [items lastObject];
        float y_v = v_h - lastItem.value*v_h + yOffset;
        float x_v = self.xAxisSpan*items.count;
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(x_v, y_v)]];
        
        if (lastItem.title&&(items.count-1)%self.xAxisTitleStep==0) {
            UIFont *font = lastItem.titleFont;
            float t_w = self.xAxisTitleStep*self.xAxisSpan;
            CGRect rect = CGRectMake(x_v - t_w/2, h - self.bottom + self.spanForTitle, t_w, font.lineHeight);
            UILabel *la = [[UILabel alloc] initWithFrame:rect];
            la.text = lastItem.title;
            la.textColor = lastItem.titleColor;
            la.font = lastItem.titleFont;
            la.textAlignment = NSTextAlignmentCenter;
            la.backgroundColor = [UIColor clearColor];
            [shapeView addSubview:la];
        }
        
        if (!lastItem.keyPoint) {
            [dotPath appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(x_v, y_v) radius:lastItem.dotRadius startAngle:0 endAngle:2*M_PI clockwise:YES]];
        }else{
            CALayer *layer = [CALayer layer];
            layer.frame = CGRectMake(0, 0, lastItem.dotRadius*2, lastItem.dotRadius*2);
            layer.cornerRadius = lastItem.dotRadius;
            layer.backgroundColor = lastItem.keyColor.CGColor;
            layer.position = CGPointMake(x_v, y_v);
            [shapeLayer addSublayer:layer];
            
            UILabel *infoLa = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 15)];
            infoLa.attributedText = lastItem.valueStr;
            CGSize size = [infoLa sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MIN)];
            infoLa.frame = CGRectMake(x_v-size.width/2, y_v-lastItem.dotRadius-4-size.height, size.width, size.height);
            [shapeView addSubview:infoLa];
        }
        dotLayer.path   = [dotPath CGPath];
    }
    shapeLayer.masksToBounds = YES;
    [pointDict setObject:points forKey:@(shapeCnt)];
    if (animationTime>0) {
        [shapeLayer addAnimation:[self lineAnimation:animationTime] forKey:@"lineAnimation"];
    }
    float c_w = (items.count+1)*self.xAxisSpan - self.contentXOffset;
    CGRect rect = shapeLayer.frame;
    rect.size.width = c_w;
    shapeLayer.frame = rect;
    
    CGRect dotRect = dotLayer.frame;
    dotRect.size.width = c_w;
    dotLayer.frame = dotRect;
    
    if (c_w>cntSc.contentSize.width) {
        [cntSc setContentSize:CGSizeMake(c_w, cntSc.contentSize.height)];
    }
    return shapeView.flag;
}
-(void)emptyData {
    [cntSc.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cntSc.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}
-(void)scrollOffset:(CGPoint)offset{
    [cntSc setContentOffset:offset animated:YES];
}
-(UIScrollView *)getCntSc{
    return cntSc;
}
@end
