//
//  QMLBarChartView.h
//  testQMLKit
//
//  Created by Myron on 14/12/22.
//  Copyright (c) 2014年 Myron. All rights reserved.
//

#import "QMLView.h"

@interface QMLBarChartView : QMLView
@property(nonatomic,QML_DEFINE_PRO_RETAIN)NSArray *values;
-(void)loadData:(NSArray *)data animation:(BOOL)animation;
@end
