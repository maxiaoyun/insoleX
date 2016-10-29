//
//  QMLAlertView.h
//  USENSE
//
//  Created by 马小云 on 16/1/26.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLView.h"
#import "QMLAlertAction.h"

@protocol QMLDrawProtocol <NSObject>

-(QMLView *)draw;

@end

@interface QMLAlertView : QMLView<QMLDrawProtocol>
@property (nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *contentBgColor;
@property (nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *contentBorderColor;
@property (nonatomic,assign)CGFloat contentBorderWidth;

@property (nonatomic,readonly)QMLEdge *contentEdge;
@property (nonatomic,readonly)QMLEdge *titleEdge;
@property (nonatomic,assign)CGFloat contentWidth;
@property (nonatomic,assign)CGFloat contentRadius;
@property (nonatomic,assign)QMLSeparatorType separatorType;
@property (nonatomic,assign)QMLPosition position;
@property (nonatomic,readonly)BOOL autoDismiss;

-(id)initWithTitle:(NSString *)title;
-(id)initWithMsg:(NSString *)msg;
-(id)initWithTitle:(NSString *)title msg:(NSString *)msg actions:(NSArray<QMLAlertAction *> *)actions;
-(void)show;
@end
