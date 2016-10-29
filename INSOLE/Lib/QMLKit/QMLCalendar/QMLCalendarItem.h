//
//  QMLCalendarItem.h
//  testQMLKit
//
//  Created by Myron on 15/11/2.
//  Copyright © 2015年 Myron. All rights reserved.
//

#import "QMLObj.h"

@interface QMLCalendarItem : QMLObj
@property(nonatomic,copy)NSString *title;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIFont *font;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *titleColor;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *bgColor;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *otherTitleColor;
@end
