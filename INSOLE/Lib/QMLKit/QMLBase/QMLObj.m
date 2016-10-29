//
//  QMLObj.m
//  testQMLKit
//
//  Created by Myron on 14/12/17.
//  Copyright (c) 2014年 Myron. All rights reserved.
//

#import "QMLObj.h"
#import <objc/runtime.h>
#import "QMLLog.h"
#import "QMLDefine.h"

@implementation QMLObj
-(id)init{
    if (self=[super init]) {
        [self setupDefineValues];
    }
    return self;
}
-(void)setupDefineValues{};
-(NSDictionary *)proDict
{
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    unsigned int proCount=0;
    objc_property_t *proList = class_copyPropertyList([self class], &proCount);
    for (int i=0; i<proCount; i++) {
        const char *proName=property_getName(proList[i]);
        NSString *key=[NSString stringWithUTF8String:proName];
        id value=[self valueForKey:key];
        if (value) {
            [dict setObject:value forKey:key];
        }
    }
    free(proList);
    return dict;
}
-(NSString *)description{
    NSMutableString *str=[NSMutableString string];
    unsigned int proCount=0;
    objc_property_t *proList = class_copyPropertyList([self class], &proCount);
    for (int i=0; i<proCount; i++) {
        const char *proName=property_getName(proList[i]);
        id value=[self valueForKey:[NSString stringWithUTF8String:proName]];
        [str appendFormat:@"\n%s:%@",proName,value];
    }
    [str appendFormat:@"\n"];
    free(proList);
    return str;
}
- (void)dealloc
{
    DEALLOC_PRINT;
#if __has_feature(objc_arc)
#else
    [super dealloc];
#endif
}
@end
