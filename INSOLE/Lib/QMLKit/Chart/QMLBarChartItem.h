//
//  QMLBarChartItem.h
//  testQMLKit
//
//  Created by Myron on 15/3/17.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLChartItem.h"
#import "QMLLog.h"

@interface QMLBarChartItem : QMLChartItem
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *barColor;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *titleColor;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIFont  *titleFont;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,assign)float barWidth;
@end
