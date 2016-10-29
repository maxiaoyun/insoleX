//
//  QMLView.h
//  testQMLKit
//
//  Created by Myron on 14/12/17.
//  Copyright (c) 2014年 Myron. All rights reserved.
//

#import "QMLObj.h"
IB_DESIGNABLE
@interface QMLView : UIView
@property(nonatomic,copy)void(^willMoveToSuperview)(UIView *);
-(void)setupDefineValues;
@end
