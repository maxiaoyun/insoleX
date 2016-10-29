//
//  QMLPieChartView.h
//  testQMLKit
//
//  Created by Myron on 15/10/28.
//  Copyright © 2015年 Myron. All rights reserved.
//

#import "QMLView.h"

@interface QMLPieChartView : QMLView
@property(nonatomic,assign)float loopWidth;
@property(nonatomic,assign)float padding;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *loopBgColor;
-(void)addPie:(NSArray *)items animationTime:(float)animationTime;
@end
