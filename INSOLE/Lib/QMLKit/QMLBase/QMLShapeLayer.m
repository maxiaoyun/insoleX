//
//  QMLShapeLayer.m
//  testQMLKit
//
//  Created by Myron on 14/12/22.
//  Copyright (c) 2014年 Myron. All rights reserved.
//

#import "QMLShapeLayer.h"
#import "QMLLog.h"
@implementation QMLShapeLayer
- (void)dealloc
{
    DEALLOC_PRINT;
#if __has_feature(objc_arc)
#else
    [super dealloc];
#endif
}
@end
