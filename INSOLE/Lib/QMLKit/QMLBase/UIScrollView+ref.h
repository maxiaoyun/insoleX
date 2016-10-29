//
//  UIScrollView+ref.h
//  testQMLKit
//
//  Created by Myron on 15/7/31.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QMLKit.h"

typedef struct UBCStatus{
    unsigned char addObserverAlready:1;
    unsigned char dragging:1;
    unsigned char shouldRef:1;  //是否达到刷新临界值
    unsigned char loading:1;    //是否正在刷新
    unsigned char isLast:1;     //是否加载完成
    
    
    unsigned char undefine:3;
}UBCStatus;

@protocol QMLRefProtocol <NSObject>

@required
@property(nonatomic,assign)UBCStatus status;
@optional
@property(nonatomic,assign)float pullProgess;

@end

@interface QMLRefView : QMLView<QMLRefProtocol>
@end

@interface UIScrollView (ref)
@property(nonatomic,assign)unsigned char status;
@property(nonatomic,copy)void(^refAction)();
@property(nonatomic,assign)BOOL shouldPullUpAction;
@property(nonatomic,assign)BOOL shouldPullDownAction;
@property(nonatomic,copy)void(^pullUpAction)();
-(void)addRefView;//add之后 释放时 一定要remove ...
-(void)addCustomRefView:(QMLRefView *)view;
-(void)addPullUpRefView:(QMLRefView *)view;
-(void)removeRefView;
-(void)endRef:(float)top;
-(void)endPullUpRef:(float)bottom;
-(void)beginRef:(float)top;

-(QMLView<QMLRefProtocol> *)pullUpRefView;
@end
