//
//  QMLScrollLabel.h
//  testQMLKit
//
//  Created by Myron on 15/3/21.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLView.h"

typedef enum : NSUInteger {
    QMLScrollLabelTypeOrder,
    QMLScrollLabelTypeCircle,
    QMLScrollLabelTypeRevert
} QMLScrollLabelType;


@interface QMLScrollLabel : QMLView
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *textColor;
@property(nonatomic,copy)NSString *text;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIFont *font;
@property(nonatomic,assign) QMLScrollLabelType type;
@end
