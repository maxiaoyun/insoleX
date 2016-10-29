//
//  QMLPageControl.m
//  testQMLKit
//
//  Created by Myron on 16/4/23.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLPageControl.h"
@interface QMLPageControl()
{
    float span;
    float boundSpan;
    float lastSelectIndex;

    UIView *contentView;
}
@end
@implementation QMLPageControl
-(void)setupDefineValues{
    [super setupDefineValues];
    self.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageIndicatorTintColor        = COLOR_WITH_RGB(245, 250, 249);
    self.position = QMLPositionRight;
    span = 10;
    self.indicatorWidth = 8;
    self.currentIndicatorWidth = 8;
}
-(void)setNumberOfPages:(int)numberOfPages{
    _numberOfPages = numberOfPages;
    [self refView];
}
-(void)refView{
    if (contentView) {
        [contentView removeFromSuperview];
    }
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, h)];
    [self addSubview:contentView];
    float x = 0;
    for (int i=0; i<self.numberOfPages; i++) {
        UIView  *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, self.indicatorWidth, self.indicatorWidth)];
        indicatorView.clipsToBounds = YES;
        indicatorView.tag = 10+i;
        indicatorView.layer.cornerRadius = self.indicatorWidth/2;
        indicatorView.backgroundColor = self.pageIndicatorTintColor;
        indicatorView.center = CGPointMake(indicatorView.center.x, h/2);
        [contentView addSubview:indicatorView];
        x += span;
        x += self.indicatorWidth;
    }
    if (x>0) {
        x -= self.indicatorWidth;
    }
    x += (self.currentIndicatorWidth-self.indicatorWidth)/2;
    CGRect cntRect = contentView.frame;
    cntRect.size.width = x;
    contentView.frame = cntRect;
    
    switch (self.position) {
        case QMLPositionCenter:
            contentView.center = CGPointMake(w/2, h/2);
            break;
        case QMLPositionLeft:
            contentView.center = CGPointMake(cntRect.size.width/2, h/2);
            break;
        case QMLPositionRight:
            contentView.center = CGPointMake(w - cntRect.size.width/2, h/2);
            break;
            
        default:
            break;
    }
    if (self.hidesForSinglePage&&self.numberOfPages < 2) {
        contentView.hidden = YES;
    }else{
        contentView.hidden = NO;
    }
}
-(void)setCurrentPage:(int)currentPage{
    
    _currentPage = currentPage;
    
    float h = self.frame.size.height;
    if (!contentView) {
        [self refView];
        
    }else{
        UIView *l_view = [contentView viewWithTag:lastSelectIndex+10];
        CGRect l_rect = l_view.frame;
        l_view.backgroundColor = self.pageIndicatorTintColor;
        l_rect.size.width = self.indicatorWidth;
        l_rect.size.height = self.indicatorWidth;
        l_view.frame = l_rect;
        l_view.layer.cornerRadius = self.indicatorWidth/2;
        l_view.center = CGPointMake((span+self.indicatorWidth)*lastSelectIndex+self.indicatorWidth/2, h/2);
    }
    UIView *view = [contentView viewWithTag:_currentPage+10];
    view.backgroundColor = self.currentPageIndicatorTintColor;
    CGRect rect = view.frame;
    rect.size.width = self.currentIndicatorWidth;
    rect.size.height = self.currentIndicatorWidth;
    view.frame = rect;
    view.layer.cornerRadius = self.currentIndicatorWidth/2;
    view.center = CGPointMake((span+self.indicatorWidth)*_currentPage+self.indicatorWidth/2, h/2);
    
    lastSelectIndex = _currentPage;
}
-(void)setHidesForSinglePage:(int)hidesForSinglePage{
    _hidesForSinglePage = hidesForSinglePage;
    if (_hidesForSinglePage&&self.numberOfPages < 2) {
        contentView.hidden = YES;
    }else{
        contentView.hidden = NO;
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
}
@end
