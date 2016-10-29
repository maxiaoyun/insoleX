//
//  QMLBarChartItem.m
//  testQMLKit
//
//  Created by Myron on 15/3/17.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLBarChartItem.h"


@implementation QMLBarChartItem
-(void)setupDefineValues{
    [super setupDefineValues];
    self.titleFont  = [UIFont systemFontOfSize:10];
    self.titleColor = [UIColor whiteColor];
}
- (void)dealloc
{
    DEALLOC_PRINT;
#if __has_feature(objc_arc)
    
#else
    [_barColor release];
    [_titleFont release];
    [_titleFont release];
    [_title release];
    [super dealloc];
#endif
}
@end
