//
//  QMLProgressView.h
//  testQMLKit
//
//  Created by Myron on 14/12/30.
//  Copyright (c) 2014年 Myron. All rights reserved.
//

#import "QMLDefine.h"
#import "QMLView.h"
IB_DESIGNABLE
typedef enum:NSUInteger{
    QMLProgressViewDefault,
    QMLProgressViewRound,
    QMLProgressViewPie,
    QMLProgressViewPath
}QMLProgressViewType;
typedef enum : NSUInteger {
    QMLProgressViewBorderTypePlain,
    QMLProgressViewBorderTypeRound,//暂不支持
    QMLProgressViewBorderTypeDoubleRound
} QMLProgressViewBorderType;

//IB_DESIGNABLE
@interface QMLProgressView : QMLView
@property(nonatomic,assign) QMLProgressViewType        type;
@property(nonatomic,assign) QMLProgressViewBorderType  borderType;
@property(nonatomic,QML_DEFINE_PRO_RETAIN) UIColor *   defaultColor;
@property(nonatomic,QML_DEFINE_PRO_RETAIN) IBInspectable UIColor *   progressColor;
@property(nonatomic,assign)IBInspectable float                      progress;     //0-1
@property(nonatomic,assign) float                      progressWidth;

@property(nonatomic,QML_DEFINE_PRO_RETAIN) UIBezierPath *path;


@property(nonatomic,copy)VVBlock                      progressChanged;
@end
