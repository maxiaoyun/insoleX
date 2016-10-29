//
//  QMLCalendarView.m
//  testQMLKit
//
//  Created by Myron on 15/11/2.
//  Copyright © 2015年 Myron. All rights reserved.
//

#import "QMLCalendarView.h"
#import "QMLCalendarCell.h"
#import "QMLCalendarItem.h"
#import "QMLDefine.h"
#import "QMLLog.h"
@interface QMLCalendarView ()
{
    QMLView *contentView;
    QMLCalendarCell *titleView;
    NSMutableArray *dayArr;
    NSMutableArray *cellArr;
}
@end
@implementation QMLCalendarView
-(void)setupDefineValues{
    [super setupDefineValues];
    self.cellHeight = 44;
    self.titleHeight = 30;
    self.titleFont = [UIFont systemFontOfSize:12];
    self.cellFont = [UIFont systemFontOfSize:14];
    dayArr = [NSMutableArray array];
    cellArr = [NSMutableArray array];
    self.textColor = [UIColor darkGrayColor];
    self.otherTextColor = [UIColor lightGrayColor];
    self.titleColor = [UIColor blackColor];
    self.todayTextColor = [UIColor orangeColor];
    self.transitionTime = .5;
    self.clipsToBounds = YES;
    self.titlebgColor = [UIColor whiteColor];
}
-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    
    if (!titleView) {
        NSMutableArray *arr = [NSMutableArray array];
        float w = self.frame.size.width;
        for (int i=0;i<self.titles.count; i++) {
            QMLCalendarItem *item = [[QMLCalendarItem alloc] init];
            item.title = [self.titles objectAtIndex:i];
            item.titleColor = self.titleColor;
            item.bgColor = [UIColor clearColor];
            item.font = self.titleFont;
            [arr addObject:item];
        }
        titleView = [[QMLCalendarCell alloc] initWithFrame:CGRectMake(0, 0, w, self.titleHeight)];
        titleView.backgroundColor = self.titlebgColor;
        titleView.items = arr;
        [self addSubview:titleView];
    }

}
-(QMLView *)createCalendarWithYear:(int)year month:(int)month{
    
    float w = self.frame.size.width;
    float h = 0;
    [dayArr removeAllObjects];
    [cellArr removeAllObjects];
    QMLView *cntView = [[QMLView alloc] initWithFrame:CGRectMake(0, 0, w, 10)];
    
    __weak typeof(self)bSelf = self;
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString *dateString=[NSString stringWithFormat:@"%d-%02d-01",year,month];
    NSDate *date=[formatter dateFromString:dateString];
    NSDateComponents *com=[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    int week=(int)com.weekday;  //@"周日 1",@"周一 2",@"周二 3",@"周三 4",@"周四 5",@"周五 6",@"周六 7"];
    int dayCount=31;
    if (month==2) {
        dayCount=(year%100!=0&&year%4==0)?29:28;
    }else if (month==4||month==6||month==9||month==11){
        dayCount=30;
    }
    [formatter setDateFormat:@"dd"];
    NSString *lastDay=[formatter stringFromDate:[NSDate dateWithTimeInterval:-24*3600 sinceDate:date]];
    [formatter setDateFormat:@"yyyy"];
    int t_year = [[formatter stringFromDate:[NSDate date]] intValue];
    [formatter setDateFormat:@"MM"];
    int t_month = [[formatter stringFromDate:[NSDate date]] intValue];
    [formatter setDateFormat:@"dd"];
    int t_day = [[formatter stringFromDate:[NSDate date]] intValue];
    //first
    NSMutableArray *firstWeek=[NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0"]];
    for (int i=0; i<week-1; i++) {
        firstWeek[week-1-i-1]=[NSString stringWithFormat:@"%d",[lastDay intValue]-i];
    }
    int currentDay=1;
    for (int i=week-1; i<7; i++)
    {
        firstWeek[i]=[NSString stringWithFormat:@"%d",currentDay];
        currentDay++;
    }
    [dayArr addObject:firstWeek];
    
    NSMutableArray *firstWeekItems = [NSMutableArray array];
    for (int i=0;i<7; i++) {
        QMLCalendarItem *item = [[QMLCalendarItem alloc] init];
        item.title = firstWeek[i];
        item.titleColor = (t_year==year&&t_month==month&&[[item title] intValue]==t_day)?self.todayTextColor:self.textColor;
        item.otherTitleColor = self.otherTextColor;
        item.bgColor = [UIColor clearColor];
        item.font = self.cellFont;
        [firstWeekItems addObject:item];
    }
    QMLCalendarCell *firstWeekCell = [[QMLCalendarCell alloc] initWithFrame:CGRectMake(0, h, w, self.cellHeight)];
    firstWeekCell.backgroundColor = [UIColor clearColor];
    firstWeekCell.items = firstWeekItems;
    firstWeekCell.type = QMLCalendarCellTypeFirstWeek;
    firstWeekCell.cellClick = ^(int index){
        [bSelf cellClickWithIndex:index location:0 cellType:QMLCalendarCellTypeFirstWeek];
    };
    [cntView addSubview:firstWeekCell];
    [cellArr addObject:firstWeekCell];
    
    h += self.cellHeight;
    
    //normal
    int location = 1;
    do {
        NSMutableArray *weeks=[NSMutableArray arrayWithCapacity:7];
        for (int i=0; i<7; i++) {
            [weeks addObject:[NSString stringWithFormat:@"%d",currentDay+i]];
        }
        [dayArr addObject:weeks];
        
        NSMutableArray *weekItems = [NSMutableArray array];
        for (int i=0;i<7; i++) {
            QMLCalendarItem *item = [[QMLCalendarItem alloc] init];
            item.title = weeks[i];
            item.titleColor = (t_year==year&&t_month==month&&[[item title] intValue]==t_day)?self.todayTextColor:self.textColor;
            item.bgColor = [UIColor clearColor];
            item.font = self.cellFont;
            [weekItems addObject:item];
        }
        
        QMLCalendarCell *cell=[[QMLCalendarCell alloc] initWithFrame:CGRectMake(0, h, w, self.cellHeight)];
        cell.backgroundColor = [UIColor clearColor];
        cell.items = weekItems;
        cell.type = QMLCalendarCellTypeNormal;
        [cntView addSubview:cell];
        
        
        [cellArr addObject:cell];
        
        cell.cellClick = ^(int index){
            [bSelf cellClickWithIndex:index location:location cellType:QMLCalendarCellTypeNormal];
        };
        
        h += self.cellHeight;
        location ++;
        
        currentDay+=7;
    } while (currentDay<=dayCount-7);
    
    
    //last
    NSMutableArray *lastWeek=[NSMutableArray arrayWithCapacity:7];
    for (int i=0; i<7; i++) {
        if (currentDay>dayCount) {
            currentDay=currentDay-dayCount;
        }
        [lastWeek addObject:[NSString stringWithFormat:@"%d",currentDay]];
        currentDay++;
    }
    [dayArr addObject:lastWeek];
    
    NSMutableArray *lastWeekItems = [NSMutableArray array];
    for (int i=0;i<7; i++) {
        QMLCalendarItem *item = [[QMLCalendarItem alloc] init];
        item.title = lastWeek[i];
        item.titleColor = (t_year==year&&t_month==month&&[[item title] intValue]==t_day)?self.todayTextColor:self.textColor;
        item.otherTitleColor = self.otherTextColor;
        item.bgColor = [UIColor clearColor];
        item.font = self.cellFont;
        [lastWeekItems addObject:item];
    }
    QMLCalendarCell *lastCell=[[QMLCalendarCell alloc] initWithFrame:CGRectMake(0, h, w, self.cellHeight)];
    lastCell.backgroundColor = [UIColor clearColor];
    lastCell.items = lastWeekItems;
    lastCell.cellClick = ^(int index){
        [bSelf cellClickWithIndex:index location:location cellType:QMLCalendarCellTypeLastWeek];
    };
    lastCell.type = QMLCalendarCellTypeLastWeek;
    [cntView addSubview:lastCell];
    
    [cellArr addObject:lastCell];
    
    
    h += self.cellHeight;
    
    CGRect rect = cntView.frame;
    rect.size.height = h;
    cntView.frame = rect;
    
    return cntView;
}
-(void)showYear:(int)year month:(int)month{
    [self gotoYear:year month:month animation:NO direction:QMLDirectionRight];
}
-(void)gotoYear:(int)year month:(int)month animation:(BOOL)animation direction:(QMLDirection)direction {
    _year = year;_month = month;
    if(self.calendarWillChangedTo){
        self.calendarWillChangedTo(_year,_month);
    }
    QMLView *lastContentView = contentView;
    float w = self.frame.size.width;
    float y = titleView.frame.size.height;
    
    contentView = [self createCalendarWithYear:year month:month];
    CGRect cntRect = contentView.frame;
    cntRect.origin.y = y;
    contentView.frame = cntRect;
    
    [self addSubview:contentView];
    [self adjustFrame];
    
    if (!animation) {
        [lastContentView removeFromSuperview];
        return;
    }
    
    float h = contentView.frame.size.height;
    
    CGRect o_cntRect = contentView.frame;
    switch (direction) {
        case QMLDirectionRight:
            o_cntRect.origin.x = w;
            break;
        case QMLDirectionLeft:
            o_cntRect.origin.x = -w;
            break;
        case QMLDirectionUp:
            o_cntRect.origin.y = h;
            break;
        case QMLDirectionDown:
            o_cntRect.origin.y = -h;
            break;
            
        default:
            break;
    }
    contentView.frame = o_cntRect;
    
    
    [UIView animateWithDuration:self.transitionTime animations:^{
        CGRect lastRect = lastContentView.frame;
        
        switch (direction) {
            case QMLDirectionRight:
            {
                lastRect.origin.x = -w;
            }
                break;
            case QMLDirectionLeft:
            {
                lastRect.origin.x = w;
            }
                break;
            case QMLDirectionUp:
            {
                lastRect.origin.y = -h;
            }
                break;
            case QMLDirectionDown:
            {
                lastRect.origin.y = h;
            }
                break;
                
            default:
                break;
        }
        contentView.frame = cntRect;
        lastContentView.frame = lastRect;
        
    } completion:^(BOOL finished) {
        [lastContentView removeFromSuperview];
    }];
    
}
-(void)adjustFrame{
    CGRect rect = self.frame;
    rect.size.height = contentView.frame.size.height + titleView.frame.size.height;
    self.frame= rect;
    if (self.frameChangedTo) {
        self.frameChangedTo(rect);
    }
    QMLog(@"QMLCalendarView.frame:%@",[NSValue valueWithCGRect:rect]);
}
-(void)gotoPreMonth{
    int year = self.year;
    int month = self.month-1;
    if (month<1) {
        month = 12;
        year --;
    }
    [self gotoYear:year month:month animation:YES direction:QMLDirectionLeft];
}
-(void)gotoNextMonth{
    int year = self.year;
    int month = self.month+1;
    if (month>12) {
        year ++;
        month = 1;
    }
    [self gotoYear:year month:month animation:YES direction:QMLDirectionRight];
}
-(void)cellClickWithIndex:(int)index location:(int)location cellType:(QMLCalendarCellType)type
{
    NSArray *week = [dayArr objectAtIndex:location];
    int day = [[week objectAtIndex:index] intValue];
    QMLog(@"index:%d location:%d day:%d",index,location,day);
    if(type==QMLCalendarCellTypeFirstWeek){
        if(day>7){
            [self gotoPreMonth];
        }else{
            if (self.selectedDay) {
                self.selectedDay(day);
            }
        }
    }
    if (type==QMLCalendarCellTypeLastWeek) {
        if (day<7) {
            [self gotoNextMonth];
        }else{
            if (self.selectedDay) {
                self.selectedDay(day);
            }
        }
    }
    if (type == QMLCalendarCellTypeNormal&&self.selectedDay) {
        if (self.selectedDay) {
            self.selectedDay(day);
        }
    }
}

-(QMLCalendarCell *)getCalendarCellWithDay:(int)day index:(int*)index {
    for (int i=0; i<dayArr.count; i++) {
        NSArray *week = [dayArr objectAtIndex:i];
        for (int j = 0;j<week.count;j++) {
            NSString *dayStr = [week objectAtIndex:j];
            if ([dayStr intValue]==day) {
                QMLCalendarCell *cell = [cellArr objectAtIndex:i];
                if (day<7&&cell.type==QMLCalendarCellTypeLastWeek) {
                    continue;
                }if (day>7&&cell.type==QMLCalendarCellTypeFirstWeek) {
                    continue;
                }
                if (index) {
                    *index = j;
                }
                return cell;
            }
        }
    }
    return nil;
}
@end
