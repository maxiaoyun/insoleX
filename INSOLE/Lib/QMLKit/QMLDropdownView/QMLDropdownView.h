//
//  QMLDropdownView.h
//  testQMLKit
//
//  Created by Myron on 15/8/8.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLKit.h"
@protocol QMLDropdownViewDelegate;
@interface QMLDropdownView : QMLView
@property(nonatomic,assign)float dropViewWidth;
@property(nonatomic,assign)float rowHeight;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *titleColor;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)UIColor *optionTitleColor;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)NSArray *options;//NSString + UIImage
@property(nonatomic,assign)float xOffset;
@property(nonatomic,assign)float yOffset;
@property(nonatomic,assign)id<QMLDropdownViewDelegate>delegate;
@property(nonatomic,assign)BOOL missModifyTitle;
@property(nonatomic,assign)float dropViewMaxHeight;
-(void)createView;
-(void)toggle;
-(void)open;
-(void)close:(BOOL)animation;
@end


@protocol QMLDropdownViewDelegate <NSObject>

@optional
-(BOOL)dropdownView:(QMLDropdownView *)dropdownView shouldOpen:(NSTimeInterval)animationTime;
-(void)dropdownView:(QMLDropdownView *)dropdownView willOpen:(NSTimeInterval)animationTime;
-(void)dropdownView:(QMLDropdownView *)dropdownView willClose:(NSTimeInterval)animationTime;
-(float)dropdownView:(QMLDropdownView *)dropdownView rowHeightAtIndex:(NSUInteger)index;
-(void)dropdownView:(QMLDropdownView *)dropdownView rowSelectedAtIndex:(NSUInteger)index;
@end