//
//  QMLCalendarView.h
//  testQMLKit
//
//  Created by Myron on 15/11/2.
//  Copyright © 2015年 Myron. All rights reserved.
//

#import "QMLShapeView.h"
#import "QMLCalendarCell.h"

/**
 *	@brief	日历视图
 */
@interface QMLCalendarView : QMLShapeView

/**
 *	@brief	当前显示的年份
 */
@property(nonatomic,readonly)int year;

/**
 *	@brief	当前显示的月份
 */
@property(nonatomic,readonly)int month;

/**
 *	@brief	当前选中的日期
 */
@property(nonatomic,readonly)int day;

/**
 *	@brief	日历周视图的高度
 */
@property(nonatomic,assign)float cellHeight;

/**
 *	@brief	标题的字体
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIFont *titleFont;

/**
 *	@brief	标题的高度
 */
@property(nonatomic,assign)float titleHeight;

/**
 *	@brief	日期的字体
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIFont *cellFont;

/**
 *	@brief	标题 NSString
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)NSArray *titles;

/**
 *	@brief	标题的字体颜色
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *titleColor;

/**
 *	@brief	标题栏的背景色
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *titlebgColor;

/**
 *	@brief	当月的日期的字体颜色
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *textColor;

/**
 *	@brief	非当月的日期的字体颜色
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *otherTextColor;
/**
 *	@brief	今天的字体颜色
 */
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *todayTextColor;

/**
 *	@brief	切换月份时动画的时间
 */
@property(nonatomic,assign)float transitionTime;

/**
 *	@brief	当日历视图的frame改变时调用该block
 */
@property(nonatomic,copy)void(^frameChangedTo)(CGRect frame);

/**
 *	@brief	当选中某天是调用
 */
@property(nonatomic,copy)void(^selectedDay)(int day);

/**
 *	@brief	当日历视图将要改变要显示的月份时调用
 */
@property(nonatomic,copy)void(^calendarWillChangedTo)(int year,int month);

/**
 *	@brief	使日历显示到某年某月
 *
 *	@param 	year 	某年
 *	@param 	month 	某月
 *
 *	@return
 */
-(void)showYear:(int)year month:(int)month;

/**
 *	@brief	使日历显示到某年某月
 *
 *	@param 	year 	某年
 *	@param 	month 	某月
 *	@param 	animation 	是否动画
 *	@param 	direction 	动画方向
 *
 *	@return
 */
-(void)gotoYear:(int)year month:(int)month animation:(BOOL)animation direction:(QMLDirection)direction;
-(QMLCalendarCell *)getCalendarCellWithDay:(int)day index:(int*)index;
@end
