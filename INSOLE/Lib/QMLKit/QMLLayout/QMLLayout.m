//
//  QMLLayout.m
//  testQMLKit
//
//  Created by Myron on 14/12/17.
//  Copyright (c) 2014年 Myron. All rights reserved.
//

#import "QMLLayout.h"
#import "QMLLayoutFunction.h"

@implementation QMLLayout
+(id)getInstanceWithLayoutFile:(NSString *)name hasAsso:(BOOL) hasAsso
{
    id ins= getInstanceWithLayoutFile(name, hasAsso);
    return ins;
}

@end
