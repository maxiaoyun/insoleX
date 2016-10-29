//
//  QMLTextView.m
//  testQMLKit
//
//  Created by Myron on 15/1/20.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "QMLTextView.h"
#import "QMLUnit.h"
@interface QMLTextView ()
{
    UITextView *placeholderVi;
}
@end
@implementation QMLTextView
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupDefineValues];
    }
    return self;
}
-(void)setupDefineValues{
    
}
- (NSUInteger)numberOfLines
{
    return fabs(self.contentSize.height/self.font.lineHeight);
}
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    if ([QMLUnit isValueString:_placeholder]) {
        if (!placeholderVi) {
            placeholderVi = [[UITextView alloc] initWithFrame:self.bounds];
            placeholderVi.font = [self font];
            placeholderVi.text = placeholder;
            placeholderVi.userInteractionEnabled = NO;
            placeholderVi.textColor = COLOR_WITH_RGB(0x99, 0x99, 0x99);
            placeholderVi.backgroundColor = [UIColor clearColor];
            placeholderVi.textContainer.lineFragmentPadding = self.textContainer.lineFragmentPadding;
            [self addSubview:placeholderVi];
        }
        placeholderVi.text = _placeholder;
    }else{
        [placeholderVi removeFromSuperview];
        placeholderVi = nil;
    }
    if (self.text.length>0) {
        [placeholderVi removeFromSuperview];
        placeholderVi = nil;
    }
}
-(void)textChanged{
    if (self.text.length>0) {
        [placeholderVi removeFromSuperview];
        placeholderVi = nil;
    }else{
        [self setPlaceholder:self.placeholder];
    }
}
-(void)layoutSubviews{
    placeholderVi.frame = self.bounds;
}
@end
