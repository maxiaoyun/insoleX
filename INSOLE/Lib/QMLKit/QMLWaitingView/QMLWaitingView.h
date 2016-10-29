//
//  QMLWaitingView.h
//  testQMLKit
//
//  Created by Myron on 15/7/15.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLView.h"

typedef enum:NSUInteger{
    QMLWaitingViewDefault,
    QMLWaitingViewRunningRound
}QMLWaitingViewType;

@interface QMLWaitingView : QMLView
@property(nonatomic,assign)QMLWaitingViewType type;
-(void)startAnimation:(BOOL)repeat;
@end
