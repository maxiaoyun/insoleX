//
//  QMLInputView.h
//  testQMLKit
//
//  Created by Myron on 15/1/20.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLView.h" 

@protocol QMLInputViewDelegate ;
@interface QMLInputView : QMLView
@property(nonatomic,assign)NSString *text;
@property(nonatomic,assign)id<QMLInputViewDelegate>delegate;
@property(nonatomic,copy)NSString *placeholder;
+(QMLInputView *)defaultInputView;
-(void)resignFirstResponder;
@end

@protocol QMLInputViewDelegate <NSObject>

@optional
-(void)inputView:(QMLInputView *)inputView frameChangedTo:(CGRect)frame;
-(void)inputViewWillShow:(QMLInputView *)inputView;
-(void)inputViewWillHidden:(QMLInputView *)inputView;
@end