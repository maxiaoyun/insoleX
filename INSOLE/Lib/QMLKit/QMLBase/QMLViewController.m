//
//  QMLViewController.m
//  testQMLKit
//
//  Created by Myron on 14/12/17.
//  Copyright (c) 2014年 Myron. All rights reserved.
//

#import "QMLViewController.h"
#import "QMLLog.h"
@implementation QMLViewController
- (void)dealloc
{
    DEALLOC_PRINT;
#if __has_feature(objc_arc)
#else
    [super dealloc];
#endif
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
}
@end
