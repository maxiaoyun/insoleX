//
//  QMLScrollLabel.m
//  testQMLKit
//
//  Created by Myron on 15/3/21.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLScrollLabel.h"
#import "QMLDrawLabel.h"
#import "QMLLog.h"

#define QMLSCROLLLABEL_SCROLL_SPEED  3
#define QMLSCROLLLABEL_SCROLL_TIME_INTERVAL .1F

@interface QMLScrollLabel ()
{
    BOOL shouldScroll;
    float scrollSpeed;
}
@end
@implementation QMLScrollLabel

- (void)dealloc
{
    DEALLOC_PRINT;
#if __has_feature(objc_arc)
    
#else
    [_textColor release];
    [_text release];
    [_font release];
    [super dealloc];
#endif
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (!newSuperview) {
        shouldScroll = NO;
    }
}
-(void)setupDefineValues
{
    [super setupDefineValues];
    self.textColor = [UIColor blackColor];
    self.font = [UIFont systemFontOfSize:15];
    self.type = QMLScrollLabelTypeOrder;
}
-(void)setType:(QMLScrollLabelType)type
{
    _type=type;
    scrollSpeed=fabsf(scrollSpeed);
    [self createView];
}
-(void)createView
{
    self.clipsToBounds  =YES;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
#if __has_feature(objc_arc)
    QMLDrawLabel *label=[[QMLDrawLabel alloc] initWithFrame:self.bounds];
#else
    QMLDrawLabel *label=[[[QMLDrawLabel alloc] initWithFrame:self.bounds] autorelease];
#endif
    label.backgroundColor=[UIColor clearColor];
    label.tag=1;
    label.text = self.text;
    label.font = self.font;
    label.textColor = self.textColor;
    [self addSubview:label];
    [label adjustFrame];
    
    float contentWidth=label.width;
    
    if (contentWidth>self.bounds.size.width) {
        
        if (self.type==QMLScrollLabelTypeOrder) {
#if __has_feature(objc_arc)
            QMLDrawLabel *label2=[[QMLDrawLabel alloc] initWithFrame:CGRectMake(label.width, 0, label.width, self.frame.size.height)];
#else
            QMLDrawLabel *label2=[[[QMLDrawLabel alloc] initWithFrame:CGRectMake(label.width, 0, label.width, self.frame.size.height)] autorelease];
#endif
            
            label2.backgroundColor=[UIColor clearColor];
            label2.tag=2;
            label2.text = self.text;
            label2.textColor = self.textColor;
            label2.font = self.font;
            [self addSubview:label2];
            [label2 adjustFrame];
            contentWidth+=label2.width;
        }
        
        scrollSpeed = QMLSCROLLLABEL_SCROLL_SPEED;
        shouldScroll=YES;
        [NSThread detachNewThreadSelector:@selector(scroll) toTarget:self withObject:nil];
#if __has_feature(objc_arc)
        UILongPressGestureRecognizer *longGes=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesActive:)];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenMenuController)];
#else
        UILongPressGestureRecognizer *longGes=[[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesActive:)] autorelease];
        UITapGestureRecognizer *tap=[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenMenuController)] autorelease];
#endif
        [self addGestureRecognizer:longGes];
        [self addGestureRecognizer:tap];
    }
}

-(void)scroll
{
    while (shouldScroll) {
        [NSThread sleepForTimeInterval:QMLSCROLLLABEL_SCROLL_TIME_INTERVAL];
        [self performSelectorOnMainThread:@selector(scrollOnMainThread) withObject:nil waitUntilDone:YES];
    }
    [NSThread exit];
}
-(void)scrollOnMainThread
{
    switch (self.type) {
        case QMLScrollLabelTypeCircle:
        {
            QMLDrawLabel *label=(QMLDrawLabel *)[self viewWithTag:1];
            float o_x=label.frame.origin.x;
            if (o_x<self.frame.size.width-label.width) {
                scrollSpeed=-scrollSpeed;
            }
            if (o_x>0) {
                scrollSpeed=-scrollSpeed;
            }
            o_x-=scrollSpeed;
            
            CGRect rect=label.frame;
            rect.origin.x=o_x;
            label.frame=rect;
        }
            break;
            
            
            
        case QMLScrollLabelTypeOrder:
        {
            QMLDrawLabel *label=(QMLDrawLabel *)[self viewWithTag:1];
            QMLDrawLabel *label2=(QMLDrawLabel *)[self viewWithTag:2];
            float o_x=label.frame.origin.x;
            if (label2.frame.origin.x<=0) {
                label.tag=2;
                label2.tag=1;
                o_x=0;
            }
            o_x-=scrollSpeed;
            
            label=(QMLDrawLabel *)[self viewWithTag:1];
            label2=(QMLDrawLabel *)[self viewWithTag:2];
            
            CGRect rect=label.frame;
            rect.origin.x=o_x;
            label.frame=rect;
            
            CGRect rect2=label2.frame;
            rect2.origin.x=o_x+label.width;
            label2.frame=rect2;
            
        }
            break;
            
            
            
        case QMLScrollLabelTypeRevert:
        {
            QMLDrawLabel *label=(QMLDrawLabel *)[self viewWithTag:1];
            float o_x=label.frame.origin.x;
            if (o_x<self.frame.size.width-label.width) {
                o_x=scrollSpeed;
            }
            o_x-=scrollSpeed;
            
            CGRect rect=label.frame;
            rect.origin.x=o_x;
            label.frame=rect;
        }
            break;
    }
    
}

#pragma mark--  Ges handle
-(void)longGesActive:(UILongPressGestureRecognizer *)longGes
{
    if (longGes.state==UIGestureRecognizerStateBegan) {
        [self hiddenMenuController];
        [self becomeFirstResponder];
        UIMenuItem *item=[[UIMenuItem alloc] initWithTitle:self.text action:@selector(doNothing)];
        UIMenuController *menu=[UIMenuController sharedMenuController];
        menu.menuItems=@[item];
        [menu setTargetRect:self.bounds inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
}
-(void)hiddenMenuController
{
    [self resignFirstResponder];
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}
-(void)doNothing
{
    
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return action==@selector(doNothing);
}

@end
