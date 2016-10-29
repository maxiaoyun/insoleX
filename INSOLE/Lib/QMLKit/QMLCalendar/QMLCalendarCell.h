//
//  QMLCalendarCell.h
//  testQMLKit
//
//  Created by Myron on 15/11/2.
//  Copyright © 2015年 Myron. All rights reserved.
//

#import "QMLShapeView.h"

typedef enum : NSUInteger {
    QMLCalendarCellTypeFirstWeek,
    QMLCalendarCellTypeNormal,
    QMLCalendarCellTypeLastWeek,
} QMLCalendarCellType;
@interface QMLCalendarCell : QMLShapeView
@property(nonatomic,assign)QMLCalendarCellType type;
@property(nonatomic,copy)void(^cellClick)(int index);
@property(nonatomic,QML_DEFINE_PRO_RETAIN)NSArray *items;
@end
