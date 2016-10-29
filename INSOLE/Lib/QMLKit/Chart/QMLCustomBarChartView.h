//
//  QMLCustomBarChartView.h
//  testQMLKit
//
//  Created by Myron on 15/3/17.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLView.h"
#import "QMLBarChartItem.h"

@interface QMLCustomBarChartView : QMLView
@property(nonatomic,QML_DEFINE_PRO_RETAIN)NSArray *data;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *lineColor;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *shadowColor;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIFont  *scaleFont;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *scaleColor;
@property(nonatomic,assign)float lineWidth;
@property(nonatomic,assign)float level;
@property(nonatomic,assign)float barSpan;
@property(nonatomic,assign)int levelScale;     // 一个level 对应的刻度
@property(nonatomic,assign)float maxScale;     //QMLBarChartItem  value ＝＝1  对应的刻度
@property(nonatomic,assign)QMLEdge edge;
@property(nonatomic,assign)BOOL showLevelLine;



-(float)loadData:(NSArray *)data animation:(BOOL)animation;
-(void)showLineWithHeight:(float)height;
-(void)showLineWithHeight:(float)height lineColor:(UIColor *)lineColor animation:(BOOL)animation;
-(void)showLineWithHeight:(float)height lineColor:(UIColor *)lineColor animation:(BOOL)animation span:(int)span;
-(void)showLineWithHeight:(float)height lineColor:(UIColor *)lineColor bgColor:(UIColor *)bgColor animation:(BOOL)animation span:(int)span;

-(void)redraw;
@end
