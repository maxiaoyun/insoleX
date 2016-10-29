//
//  QMLSegItem.m
//  QMLib
//
//  Created by 流云_陌陌 on 14-8-12.
//  Copyright (c) 2014年 流云_陌陌. All rights reserved.
//

#import "QMLSegItem.h"
#import "QMLLayoutFunction.h"

@implementation QMLSegItem
- (void)dealloc
{
    DEALLOC_PRINT;
#if __has_feature(objc_arc)
#else
    [_title release];
    [_defaultTextColor release];
    [_heightLightTextColor release];
    [_defaultImage release];
    [_heightLightImage release];
    [super dealloc];
#endif
}
@end
