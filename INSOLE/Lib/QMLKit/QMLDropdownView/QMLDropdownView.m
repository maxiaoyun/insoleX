//
//  QMLDropdownView.m
//  testQMLKit
//
//  Created by Myron on 15/8/8.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#define ANIMATION_TIME_INTERVAL .25
#import "QMLDropdownView.h"
@interface QMLDropdownView()
{
    UIButton *dropdownBtn;
    UIScrollView *dropView;
    BOOL opening;
    float cntHeight;
    UIImageView *dropdownImgView;
}
@end
@implementation QMLDropdownView

-(void)setupDefineValues{
    [super setupDefineValues];
    self.rowHeight = 44;
    self.dropViewWidth = self.frame.size.width;
}

-(void)setOptions:(NSArray *)options{
    _options = options;
    [self close:NO];
}
-(void)createView{
    if (!dropdownBtn) {
        dropdownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dropdownBtn.frame = self.bounds;
        
        [dropdownBtn setTitleColor:self.titleColor forState:UIControlStateNormal];
        dropdownBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [dropdownBtn setTitle:self.title forState:UIControlStateNormal];
        [dropdownBtn addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dropdownBtn];
    }
}
-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    [dropdownBtn setTitleColor:self.titleColor forState:UIControlStateNormal];
}
-(void)setTitle:(NSString *)title{
    _title = title;
    [dropdownBtn setTitle:self.title forState:UIControlStateNormal];
}
-(void)createDropView{
    if (self.superview&&!dropView) {
        float x = self.frame.origin.x;
        float y = self.frame.origin.y;
        float w = self.frame.size.width;
        float h = self.frame.size.height;
        if (self.dropViewWidth==0) {
            self.dropViewWidth = w;
        }
        dropView = [[UIScrollView alloc] initWithFrame:CGRectMake(x + self.xOffset, y+h+self.yOffset, self.dropViewWidth, 0)];
        dropView.backgroundColor = COLOR_WITH_RGB(226,233,232);
        dropView.showsVerticalScrollIndicator = NO;
        dropView.showsHorizontalScrollIndicator = NO;
        dropView.clipsToBounds = YES;
        [self.superview insertSubview:dropView belowSubview:dropdownBtn];
        
        float r_y = 0;
        for (int i = 0 ; i<self.options.count; i++) {
            float r_w = self.dropViewWidth;
            float r_h = 0;
            if ([self.delegate respondsToSelector:@selector(dropdownView:rowHeightAtIndex:)]) {
                r_h = [self.delegate dropdownView:self rowHeightAtIndex:i];
            }
            r_h = r_h>0?r_h:self.rowHeight;
            
            UIControl *row = [[UIControl alloc] initWithFrame:CGRectMake(0, r_y, r_w, r_h)];
            row.backgroundColor = COLOR_WITH_RGB(226,233,232);
            row.tag = i;
            [dropView addSubview:row];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rowClick:)];
            [row addGestureRecognizer:tap];
            
            float r_i_x = 10;
            
            id obj = [self.options objectAtIndex:i];
            if ([obj isKindOfClass:[NSString class]]) {
                UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(r_i_x, 0, r_w - r_i_x, r_h)];
                la.text = (NSString *)obj;
                la.textColor = self.optionTitleColor;
                la.font = [UIFont systemFontOfSize:15];
                [row addSubview:la];
            }
            if ([obj isKindOfClass:[UIImage class]]) {
                UIImage *img = obj;
                
                float r_i_y = 2;
                float r_i_h = (r_h-r_i_y*2);
                
                float r_i_w = img.size.width/(img.size.height/r_i_h);
                UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(r_i_x, r_i_y, r_i_w, r_i_h)];
                im.image = img;
                [row addSubview:im];
            }
            
            r_y += r_h + 1;
        }
        CGRect rect = dropView.frame;
        if (self.dropViewMaxHeight!=0) {
            rect.size.height = self.dropViewMaxHeight;
        }else{
            rect.size.height = r_y - 1;
        }
        [UIView animateWithDuration:ANIMATION_TIME_INTERVAL animations:^{
            dropView.frame = rect;
        }];
        dropView.contentSize = CGSizeMake(rect.size.width, r_y);
        
        cntHeight = rect.size.height;
    }
}
-(void)refDropdownView:(id)option{
    
    if ([option isKindOfClass:[UIImage class]]) {
        [dropdownBtn setTitle:@"" forState:UIControlStateNormal];
        UIImage *img = option;
        float r_h = dropdownBtn.frame.size.height;
        float r_i_y = 2;
        float r_i_h = (r_h-r_i_y*2);
        float r_i_w = img.size.width/(img.size.height/r_i_h);
        float r_i_x = (dropdownBtn.frame.size.width - r_i_w)/2;
        
        if (!dropdownImgView) {
            dropdownImgView = [[UIImageView alloc] initWithFrame:CGRectMake(r_i_x, r_i_y, r_i_w, r_i_h)];
            dropdownImgView.image = img;
            [dropdownBtn addSubview:dropdownImgView];
        }
        dropdownImgView.image = img;
        dropdownImgView.frame = CGRectMake(r_i_x, r_i_y, r_i_w, r_i_h);
    }else{
        if ([option isKindOfClass:[NSString class]]) {
            [dropdownBtn setTitle:option forState:UIControlStateNormal];
        }
        [dropdownImgView removeFromSuperview];
        dropdownImgView = nil;
    }
}
-(void)rowClick:(UITapGestureRecognizer *)tap{
    UIView *vi = tap.view;
    [UIView animateWithDuration:.2 animations:^{
        vi.backgroundColor = COLOR_WITH_RGB(200, 200, 200);
    }completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:.2 animations:^{
                vi.backgroundColor = COLOR_WITH_RGB(226,233,232);
            }];
        }
    }];
    if ([self.delegate respondsToSelector:@selector(dropdownView:rowSelectedAtIndex:)]) {
        [self.delegate dropdownView:self rowSelectedAtIndex:vi.tag];
    }
    if (!self.missModifyTitle) {
        [self refDropdownView:[self.options objectAtIndex:vi.tag]];
    }
    [self close:YES];
}
-(void)toggle{
    opening?[self close:YES]:[self open];
}
-(void)open{
    if (opening) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(dropdownView:shouldOpen:)]) {
        if (![self.delegate dropdownView:self shouldOpen:ANIMATION_TIME_INTERVAL]) {
            return;
        }
    }
    opening = YES;
    if([self.delegate respondsToSelector:@selector(dropdownView:willOpen:)]){
        [self.delegate dropdownView:self willOpen:ANIMATION_TIME_INTERVAL];
    }
    
    [dropView removeFromSuperview];
    dropView = nil;
    
    if (!dropView) {
        [self createDropView];
    }
}
-(void)close:(BOOL)animation{
    if ([self.delegate respondsToSelector:@selector(dropdownView:willClose:)]) {
        [self.delegate dropdownView:self willClose:ANIMATION_TIME_INTERVAL];
    }
    if (!opening) {
        return;
    }
    opening = NO;
    CGRect rect = dropView.frame;
    rect.size.height = 0;
    if (animation) {
        [UIView animateWithDuration:ANIMATION_TIME_INTERVAL animations:^{
            dropView.frame = rect;
        } ];
    }else{
        dropView.frame = rect;
    }
}
@end
