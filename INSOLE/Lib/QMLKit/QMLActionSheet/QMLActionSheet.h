//
//  QMLActionSheet.h
//  USENSE
//
//  Created by Myron on 16/1/23.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLView.h"

typedef enum : NSUInteger {
    QMLActionSheetStyleNormal,
    QMLActionSheetStyleValue1,
} QMLActionSheetStyle;


@interface QMLActionSheet : QMLView
@property (nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *contentBgColor;
@property (nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *cancelBgColor;
@property (nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *titleTextColor;
@property (nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *contentTextColor;
@property (nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *cancelTextColor;
@property (nonatomic,QML_DEFINE_PRO_RETAIN)UIFont *titleFont;
@property (nonatomic,QML_DEFINE_PRO_RETAIN)UIFont *contentFont;
@property (nonatomic,QML_DEFINE_PRO_RETAIN)UIFont *cancelFont;
@property (nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *separatorColor;
@property (nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *touchedBgColor;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *cancelText;
@property (nonatomic,assign)QMLSeparatorType separatorType;
@property (nonatomic,assign)QMLActionSheetStyle style;

//@property (nonatomic,copy)void(^getContent)(UIImage **img,NSString **text,int index);
@property (nonatomic,copy)void(^didSelectContent)(UIImage *img,NSString *text,int index,BOOL *dismiss);

@property (nonatomic,assign)float padding;
@property (nonatomic,assign)float spanForCancel;

@property (nonatomic,assign)float textMarge;

@property (nonatomic,assign)float cornerRadius;
-(void)setContent:(NSArray<UIImage*>*)imgs texts:(NSArray<NSString*>*)texts;
-(void)showInView:(UIView *)view;
@end
