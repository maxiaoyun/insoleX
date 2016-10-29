//
//  QMLInputView.m
//  testQMLKit
//
//  Created by Myron on 15/1/20.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLInputView.h"
#import "QMLTextView.h"
#import "QMLDefine.h"
#import "QMLUnit.h"

#define INPUT_HEIGHT 44
@interface QMLInputView ()<UITextViewDelegate>
{
    QMLTextView *tx;
    float currentKeyboardY;
    float maxContentHeight;
    float b_y ;
    float keyboardHeight;
}
@end

@implementation QMLInputView
+(QMLInputView *)defaultInputView{
#if __has_feature(objc_arc)
    QMLInputView *vi = [[QMLInputView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, INPUT_HEIGHT)];
#else
    QMLInputView *vi = [[QMLInputView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, INPUT_HEIGHT)];
    [vi autorelease];
#endif
    [vi createView];
    return vi;
}
-(void)setPlaceholder:(NSString *)placeholder{
    tx.placeholder = placeholder;
}
-(void)createView{
    self.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:.9];
    if (!tx) {
        float w = self.bounds.size.width;
#if __has_feature(objc_arc)
        tx = [[QMLTextView alloc] initWithFrame:CGRectMake(5, (INPUT_HEIGHT-30)/2, w - 75, 30)];
#else
        tx = [[QMLTextView alloc] initWithFrame:CGRectMake(5, (INPUT_HEIGHT-30)/2, w - 75, 30)];
        [tx autorelease]
#endif
        tx = [[QMLTextView alloc] initWithFrame:CGRectMake(5, (INPUT_HEIGHT-30)/2, w - 75, 30)];
        tx.layer.cornerRadius = 5;
        tx.delegate = self;
        tx.font = [UIFont systemFontOfSize:44/3.0];
        tx.clipsToBounds = YES;
        [self addSubview:tx];
    }
}
-(void)addObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)keyboardWillChanged:(NSNotification *)not{
    NSTimeInterval timeInterval = [[not.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    currentKeyboardY = [[not.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    keyboardHeight = [[not.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    typeof(self)bSelf = self;
    [UIView animateWithDuration:timeInterval animations:^{
        [bSelf adjustFrame];
    }];
}
-(void)removeObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        [self addObservers];
        b_y = self.frame.origin.y;
    }else{
        [self removeObservers];
    }
}
-(void)adjustFrame{
    float keyboardY = currentKeyboardY;
    
    if ([tx numberOfLines]<5) {
        CGSize size = [tx sizeThatFits:CGSizeMake(tx.frame.size.width, CGFLOAT_MAX)];
        float c_h = size.height;
        maxContentHeight = c_h;
    }
    
    
    CGRect c_rect = tx.frame;
    c_rect.size.height = maxContentHeight;
    tx.frame = c_rect;
    
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    float w_y = keyboardY - maxContentHeight - 14;
    
    CGRect rect  = self.frame;
    rect.size.height = keyboardHeight + maxContentHeight + 14;
    rect.origin.y = [win convertPoint:CGPointMake(0, w_y) toView:self.superview].y;
    if (rect.origin.y<0) {
        return;
    }
    self.frame = rect;
    
    if ([self.delegate respondsToSelector:@selector(inputView:frameChangedTo:)]) {
        [self.delegate inputView:self frameChangedTo:rect];
    }
}
-(void)resignFirstResponder{
    [tx resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(inputViewWillHidden:)]) {
        [self.delegate inputViewWillHidden:self];
    }
}
-(BOOL)becomeFirstResponder{
    BOOL s = [tx becomeFirstResponder];
    if ([self.delegate respondsToSelector:@selector(inputViewWillShow:)]) {
        [self.delegate inputViewWillShow:self];
    }
    return s;
}
-(NSString *)text{
    return tx.text;
}
-(void)setText:(NSString *)text{
    tx.text = text;
    [tx textChanged];
    [self adjustFrame];
}
#pragma mark -- UITextViewDelegate
- (BOOL)textView:(QMLTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [self adjustFrame];
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    if ([textView isKindOfClass:[QMLTextView class]]) {
        [(QMLTextView *)textView textChanged];
    }
}
@end
