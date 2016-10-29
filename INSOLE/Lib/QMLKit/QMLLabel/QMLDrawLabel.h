//
//  QMLDrawLabel.h
//  testQMLKit
//
//  Created by Myron on 15/3/21.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLView.h"
#import "QMLDefine.h"

@interface QMLDrawLabel : QMLView
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *textColor;
@property(nonatomic,copy)NSString *text;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIFont *font;
@property(nonatomic,readonly)float width;
-(void)redraw;
-(void)adjustFrame;
@end
