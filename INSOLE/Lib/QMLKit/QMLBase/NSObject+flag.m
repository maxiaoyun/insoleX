//
//  NSObject+flag.m
//  testQMLKit
//
//  Created by Myron on 15/11/15.
//  Copyright © 2015年 Myron. All rights reserved.
//

#import "NSObject+flag.h"
#import <objc/runtime.h>
static char *s_flag_NSObject_flag_pro_key = "s_flag_NSObject_flag_pro_key";
@implementation NSObject (flag)
@dynamic flag;
-(NSString *)flag{
    id obj = objc_getAssociatedObject(self, s_flag_NSObject_flag_pro_key);
    return obj;
}
-(void)setFlag:(NSString *)flag{
    [self willChangeValueForKey:@"flag"];
    objc_setAssociatedObject(self, s_flag_NSObject_flag_pro_key, flag, OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"flag"];
}
@end
