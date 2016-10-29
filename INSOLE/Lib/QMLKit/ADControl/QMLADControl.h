//
//  QMLADControl.h
//  testQMLKit
//
//  Created by Myron on 15/3/13.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLView.h"
@protocol QMLADControlDelegate;
@interface QMLADControl : QMLView
@property(nonatomic,assign)uint itemCount;
@property(nonatomic,assign)QMLDirection direction;
@property(nonatomic,assign)BOOL autoScroll;
@property(nonatomic,assign)BOOL useSwipeGes;
@property(nonatomic,assign)int currentIndex;
@property(nonatomic,assign)NSTimeInterval showTime;
@property(nonatomic,assign)NSTimeInterval transitionTime;
@property(nonatomic,assign)id<QMLADControlDelegate> delegate;
-(void)stopAnimation;
-(void)startAnimation;
-(QMLView *)getCurrentView;
-(void)showViewWithIndex:(int)index;
-(void)gotoPreView:(BOOL)animation;
-(void)gotoNextView:(BOOL)animation;
@end
@protocol QMLADControlDelegate <NSObject>
@optional
-(BOOL)adControl:(QMLADControl*)control shouldShowViewAtIndex:(int)index fromLeftToRight:(BOOL)fromLeftToRight;
-(void)adControl:(QMLADControl*)control willShowView:(QMLView *)view atIndex:(int)index fromLeftToRight:(BOOL)fromLeftToRight;
-(void)adControl:(QMLADControl*)control showView:(QMLView *)view atIndex:(int)index fromLeftToRight:(BOOL)fromLeftToRight;
@end