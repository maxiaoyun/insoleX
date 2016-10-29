//
//  QMLLineChartItem.h
//  testQMLKit
//
//  Created by Myron on 15/11/5.
//  Copyright © 2015年 Myron. All rights reserved.
//

#import "QMLChartItem.h"

@interface QMLLineChartItem : QMLChartItem
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *titleColor;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIFont  *titleFont;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,assign)BOOL keyPoint;
@property(nonatomic,assign)float dotRadius;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *keyColor;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)NSAttributedString *valueStr;
@end
