//
//  QMLView.m
//  testQMLKit
//
//  Created by Myron on 14/12/17.
//  Copyright (c) 2014年 Myron. All rights reserved.
//

#import "QMLView.h"
#import "QMLLog.h"

@implementation QMLView
- (void)dealloc
{
    DEALLOC_PRINT;
#if __has_feature(objc_arc)
#else
    [super dealloc];
#endif
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (self.willMoveToSuperview) {
        self.willMoveToSuperview(newSuperview);
    }
}
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self setupDefineValues];
    }
    return self;
}
-(id)init
{
    if (self=[super init]) {
        [self setupDefineValues];
    }
    return self;
}
-(void)setupDefineValues
{
    
}
@end
