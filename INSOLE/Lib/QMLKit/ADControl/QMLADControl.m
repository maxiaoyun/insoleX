//
//  QMLADControl.m
//  testQMLKit
//
//  Created by Myron on 15/3/13.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#define FLAG_CURRENT_VIEW  @"QMLADControl_QMLView_currentView"
#define FLAG_NEXT_VIEW     @"QMLADControl_QMLView_nextView"

#import "QMLADControl.h"
#import "QMLLog.h"
@interface QMLADControl ()
{
    QMLView *currentView;
    QMLView *nextView;
    NSTimer *timer;
    float timeCount;
    BOOL transiting;
}
@end
@implementation QMLADControl
- (void)dealloc
{
    
    DEALLOC_PRINT;
    self.delegate=nil;
    [self stopAnimation];
#if __has_feature(objc_arc)
#else
    [super dealloc];
#endif
}
-(void)setupDefineValues{
    [super setupDefineValues];
    _direction=QMLDirectionLeft;
    _showTime=2.0f;
    _transitionTime=.5f;
    _currentIndex=0;
    _autoScroll=YES;
}
-(void)setItemCount:(uint)itemCount
{
    _itemCount=itemCount;
    if (nextView) {
        [nextView removeFromSuperview];
        nextView=nil;
    }
    
    if (_itemCount>0) {
        if (!currentView) {
#if __has_feature(objc_arc)
            currentView=[[QMLView alloc] initWithFrame:self.bounds];
#else
            currentView=[[[QMLView alloc] initWithFrame:self.bounds] autorelease];
#endif
            currentView.flag=FLAG_CURRENT_VIEW;
            currentView.userInteractionEnabled=YES;
            [self addSubview:currentView];
            
            [self willShowView:currentView atIndex:self.currentIndex fromLeftToRight:NO];
            [self showViewAtIndex:self.currentIndex fromLeftToRight:NO];
        }
    }else{
        if (currentView) {
            [currentView removeFromSuperview];
            currentView=nil;
        }
    }
}
-(void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll=autoScroll;
    if (_autoScroll) {
        [self startAnimation];
    }else{
        [self stopAnimation];
    }
}
-(void)setCurrentIndex:(int)currentIndex
{
    if (self.itemCount==0) {
        _currentIndex=0;
    }else{
        _currentIndex=currentIndex<0?self.itemCount-1:currentIndex;
        _currentIndex=_currentIndex>self.itemCount-1?0:_currentIndex;
    }
}
-(void)startAnimation
{
    if (!timer&&_autoScroll) {
        timer=[NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    }
}
-(void)stopAnimation
{
    if (timer) {
        [timer invalidate];
        timer=nil;
    }
}
-(void)timerRun
{
    if (!self.superview) {
        [self stopAnimation];
        return;
    }
    timeCount+=.1f;
    if (timeCount>=_showTime&&_autoScroll)
    {
        timeCount=0;
        [self beginTransition:YES];
    }
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self stopAnimation];
    }
}
-(QMLView *)getCurrentView
{
    return currentView;
}
-(void)beginTransition:(BOOL)next
{
    transiting=YES;
    float width=self.frame.size.width;
    float height=self.frame.size.height;
    CGRect nextRect,preRect;
    switch (self.direction) {
        case QMLDirectionLeft:
            self.currentIndex=self.currentIndex+(next?1:-1);
            nextRect=CGRectMake(width, 0, width, height);
            preRect=CGRectMake(-width, 0, width, height);
            break;
        case QMLDirectionRight:
            self.currentIndex=self.currentIndex-(next?1:-1);
            nextRect=CGRectMake(-width, 0, width, height);
            preRect=CGRectMake(width, 0, width, height);
            break;
        case QMLDirectionDown:
            self.currentIndex=self.currentIndex-(next?1:-1);
            nextRect=CGRectMake(0, -height, width, height);
            preRect=CGRectMake(0, height, width, height);
            break;
        case QMLDirectionUp:
            self.currentIndex=self.currentIndex+(next?1:-1);
            nextRect=CGRectMake(0, height, width, height);
            preRect=CGRectMake(0, -height, width, height);
            break;
    }
    BOOL should = YES;
    if ([self.delegate respondsToSelector:@selector(adControl:shouldShowViewAtIndex:fromLeftToRight:)]) {
        should = [self.delegate adControl:self shouldShowViewAtIndex:self.currentIndex fromLeftToRight:!next];
    }
    if (!should) {
        transiting = NO;
        return;
    }
    if (!nextView) {
#if __has_feature(objc_arc)
        nextView=[[QMLView alloc] initWithFrame:next?nextRect:preRect];
#else
        nextView=[[[QMLView alloc] initWithFrame:next?nextRect:preRect] autorelease];
#endif
        nextView.userInteractionEnabled=YES;
        nextView.flag=FLAG_NEXT_VIEW;
        [self addSubview:nextView];
    }
    nextView.frame=next?nextRect:preRect;
    [self willShowView:nextView atIndex:self.currentIndex fromLeftToRight:!next];
    
    __block typeof(self)bSelf=self;
    [UIView animateWithDuration:self.transitionTime animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        nextView.frame=bSelf.bounds;
        currentView.frame=next?preRect:nextRect;
    } completion:^(BOOL finished) {
        [bSelf endTransition:!next];
    }];
}
-(void)endTransition:(BOOL)fromLeftToRight
{
    transiting=NO;
    [currentView removeFromSuperview];
    currentView=nextView;
    currentView.flag=FLAG_CURRENT_VIEW;
    nextView=nil;
    [self showViewAtIndex:self.currentIndex fromLeftToRight:fromLeftToRight];
}
-(void)setUseSwipeGes:(BOOL)useSwipeGes
{
    _useSwipeGes = useSwipeGes;
    if (_useSwipeGes) {
#if __has_feature(objc_arc)
        UISwipeGestureRecognizer *leftSwi = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeAction)];
        UISwipeGestureRecognizer *rightSwi=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeAction)];
#else  
        UISwipeGestureRecognizer *leftSwi=[[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeAction)] autorelease];
        UISwipeGestureRecognizer *rightSwi=[[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeAction)] autorelease];
#endif
        leftSwi.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:leftSwi];
        
        
        rightSwi.direction=UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:rightSwi];
    }else{
        for (UISwipeGestureRecognizer *swipe in self.gestureRecognizers) {
            if ([swipe isKindOfClass:[UISwipeGestureRecognizer class]]) {
                [self removeGestureRecognizer:swipe];
            }
        }
    }
}

-(void)gotoPreView:(BOOL)animation{
    [self rightSwipeAction];
}
-(void)gotoNextView:(BOOL)animation{
    [self leftSwipeAction];
}
-(void)showViewWithIndex:(int)index
{
    self.currentIndex=index;
    
    if (!nextView) {
#if __has_feature(objc_arc)
        nextView=[[QMLView alloc] initWithFrame:self.bounds];
#else
        nextView=[[[QMLView alloc] initWithFrame:self.bounds] autorelease];
#endif
        nextView.userInteractionEnabled=YES;
        nextView.flag=FLAG_NEXT_VIEW;
        [self addSubview:nextView];
    }else{
        nextView.frame=self.bounds;
    }
    
    [self willShowView:nextView atIndex:self.currentIndex fromLeftToRight:NO];
    
    [self endTransition:NO];
}
-(void)rightSwipeAction
{
    if (transiting) {
        return;
    }
    timeCount=0;
    [self beginTransition:NO];
}
-(void)leftSwipeAction
{
    if (transiting) {
        return;
    }
    timeCount=0;
    [self beginTransition:YES];
}

-(void)willShowView:(QMLView *)view atIndex:(int)index fromLeftToRight:(BOOL)fromLeftToRight
{
    if ([self.delegate respondsToSelector:@selector(adControl:willShowView:atIndex:fromLeftToRight:)])
    {
        [self.delegate adControl:self willShowView:view atIndex:index fromLeftToRight:fromLeftToRight];
    }
}
-(void)showViewAtIndex:(int)index fromLeftToRight:(BOOL)fromLeftToRight
{
    if ([self.delegate respondsToSelector:@selector(adControl:showView:atIndex:fromLeftToRight:)])
    {
        [self.delegate adControl:self showView:currentView atIndex:index fromLeftToRight:fromLeftToRight];
    }
}

@end
