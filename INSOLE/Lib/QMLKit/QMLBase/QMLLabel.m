//
//  QMLLabel.m
//  QMLRecord
//
//  Created by Myron on 15/8/27.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLLabel.h"

@implementation QMLLabel
-(void)setTapAction:(void (^)(void))tapAction{
    _tapAction = tapAction;
    if (!self.userInteractionEnabled) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
}
-(void)tap{
    if (self.tapAction) {
        self.tapAction();
    }
}
@end
