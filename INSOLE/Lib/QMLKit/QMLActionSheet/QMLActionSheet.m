//
//  QMLActionSheet.m
//  USENSE
//
//  Created by Myron on 16/1/23.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLActionSheet.h"
#import "QMLTouchView.h"
#import "QMLKit.h"
@interface QMLActionSheet()
{
    QMLView *cntView;
    BOOL animating;
}
@property(nonatomic,strong)NSArray *imgs;
@property(nonatomic,strong)NSArray *texts;
@end
@implementation QMLActionSheet
-(void)setupDefineValues{
    [super setupDefineValues];
    self.contentBgColor = COLOR_WITH_RGB(245, 250, 249);
    self.cancelBgColor  = COLOR_WITH_RGB(245, 250, 249);
    self.titleTextColor = COLOR_WITH_RGB(185, 191, 194);
    self.contentTextColor = COLOR_WITH_RGB(21, 23, 28);
    self.cancelTextColor  = COLOR_WITH_RGB(249, 98, 98);
    self.titleFont        = [UIFont systemFontOfSize:13];
    self.contentFont      = [UIFont systemFontOfSize:17];
    self.cancelFont       = [UIFont systemFontOfSize:17];
    self.separatorColor   = COLOR_WITH_RGB(200, 200, 200);
    self.touchedBgColor   = COLOR_WITH_RGB(200, 200, 200);
    self.separatorType    = QMLSeparatorTypeLine;
    self.style = QMLActionSheetStyleNormal;
    self.padding = 10;
    self.spanForCancel = 10;
    self.textMarge = 15;
    self.cornerRadius = 10;
    self.cancelText = @"Cancel";
}
-(void)setContent:(NSArray<UIImage*>*)imgs texts:(NSArray<NSString*>*)texts{
    self.imgs = imgs;
    self.texts = texts;
}
-(void)createViewWithWidth:(float)width{
    
    if (!cntView) {
        cntView = [[QMLView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
        cntView.backgroundColor = [UIColor clearColor];
        [self addSubview:cntView];
    }
    [cntView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    float w = width - 2*self.padding;
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(self.padding, 0, w, 44)];
    contentView.backgroundColor = self.contentBgColor;
    contentView.clipsToBounds = YES;
    contentView.layer.cornerRadius = self.cornerRadius;
    [cntView addSubview:contentView];
    
    float y = 0;
    if (self.title) {
        y += self.textMarge;
        UILabel *titleLa = [[UILabel alloc] initWithFrame:CGRectMake(20, y, w-40, 10)];
        titleLa.font = self.titleFont;
        titleLa.backgroundColor = [UIColor clearColor];
        titleLa.textColor = self.titleTextColor;
        titleLa.text = self.title;
        titleLa.numberOfLines = 0;
        titleLa.textAlignment = NSTextAlignmentCenter;
        CGSize size = [titleLa sizeThatFits:CGSizeMake(w - 40, CGFLOAT_MAX)];
        titleLa.frame = CGRectMake(20, y, w-40, size.height);
        [contentView addSubview:titleLa];
        
        y += size.height;
        y += self.textMarge;
        
//        if (self.separatorType==QMLSeparatorTypeLine) {
//            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y, w, .5)];
//            lineView.backgroundColor = self.separatorColor;
//            [contentView addSubview:lineView];
//            
//            y += lineView.frame.size.height;
//        }
    }
    
    __weak typeof(self)bSelf = self;

    float scale = 1.0/[[UIScreen mainScreen] scale];
    for (int i=0; i<self.texts.count; i++) {
        QMLTouchView *cellView = [[QMLTouchView alloc] initWithFrame:CGRectMake(0, y, w, 10)];
        cellView.backgroundColor = [UIColor clearColor];
        [contentView addSubview:cellView];
        
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.texts[i] attributes:@{
                                                                                                        NSFontAttributeName:self.contentFont,
                                                                                                        NSForegroundColorAttributeName:self.contentTextColor
                                                                                                        }];
        UIImage *img = nil;
        if (i<self.imgs.count) {
            img = self.imgs[i];
        }
        UIView *view = [QMLUnit createViewWithImage:img imgScale:scale span:3 text:str maxTextWidth:0 textPosition:QMLDirectionRight];
        cellView.frame = CGRectMake(0, y, w, view.frame.size.height+2*self.textMarge);
        view.center = CGPointMake(w/2, cellView.frame.size.height/2);
        [cellView addSubview:view];
        
        __weak typeof(cellView)bCellView = cellView;
        cellView.touchesBegan = ^(NSSet<UITouch *> *touches,UIEvent *event){
            bCellView.backgroundColor = bSelf.touchedBgColor;
        };
        cellView.touchesEnded = ^(NSSet<UITouch *> *touches,UIEvent *event){
            bCellView.backgroundColor = bSelf.touchedBgColor;
            [bSelf didSelectWithIndex:i];
        };
        cellView.touchesCancelled = cellView.touchesEnded;
        
        y += cellView.frame.size.height;
        
        if (i==self.texts.count-1) {
            continue;
        }
        
        if (self.separatorType==QMLSeparatorTypeLine) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y, w, .5)];
            lineView.backgroundColor = self.separatorColor;
            [contentView addSubview:lineView];
            
            y += lineView.frame.size.height;
        }
    }
    
    contentView.frame = CGRectMake(self.padding, 0, w, y);
    
    y += self.spanForCancel;
    

    QMLTouchView *cancelView = [[QMLTouchView alloc] initWithFrame:CGRectMake(self.padding, y, w, 10)];
    cancelView.backgroundColor = self.cancelBgColor;
    cancelView.clipsToBounds = YES;
    cancelView.layer.cornerRadius = self.cornerRadius;
    [cntView addSubview:cancelView];
    
    __weak typeof(cancelView)bCancelView = cancelView;
    cancelView.touchesBegan = ^(NSSet<UITouch *> *touches,UIEvent *event){
        bCancelView.backgroundColor = bSelf.touchedBgColor;
    };
    cancelView.touchesEnded = ^(NSSet<UITouch *> *touches,UIEvent *event){
        bCancelView.backgroundColor = bSelf.touchedBgColor;
        [bSelf removeSelf];
    };
    cancelView.touchesCancelled = cancelView.touchesEnded;
    
    UILabel *cancelLa = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, 10)];
    cancelLa.textAlignment = NSTextAlignmentCenter;
    cancelLa.font = self.cancelFont;
    cancelLa.text = self.cancelText;
    cancelLa.textColor = self.cancelTextColor;
    [cancelView addSubview:cancelLa];
    CGSize size = [cancelLa sizeThatFits:CGSizeMake(w, CGFLOAT_MAX)];
    cancelLa.frame = CGRectMake(0, 0, w, size.height);
    cancelView.frame = CGRectMake(self.padding, y, w, 50);
    cancelLa.center = CGPointMake(w/2, cancelView.frame.size.height/2);
    
    y += cancelView.frame.size.height + self.textMarge  ;
    
    
    CGRect rect = cntView.frame;
    rect.size.height = y;
    rect.origin.y = self.frame.size.height;
    cntView.frame = rect;
    rect.origin.y = self.frame.size.height - y;
    
    animating = YES;
    [UIView animateWithDuration:.25 animations:^{
        cntView.frame = rect;
        bSelf.backgroundColor = COLOR_WITH_RGBA(0, 0, 0, 255*.6);
    } completion:^(BOOL finished) {
        animating = NO;
    }];
}
-(void)didSelectWithIndex:(int)index
{
    if (self.didSelectContent) {
        NSString *text = self.texts[index];
        UIImage *img = nil;
        if (index<self.imgs.count) {
            img = self.imgs[index];
        }
        BOOL dissmiss = YES;
        self.didSelectContent(img,text,index,&dissmiss);
        if (dissmiss) {
            [self removeSelf];
        }
    }else{
        [self removeSelf];
    }
}
-(void)removeSelf{
    __weak typeof(self)bSelf = self;
    self.userInteractionEnabled = NO;
    CGRect rect = cntView.frame;
    rect.origin.y = self.frame.size.height;
    
    animating = YES;
    [UIView animateWithDuration:.25 animations:^{
        cntView.frame = rect;
        bSelf.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        animating = NO;
        [bSelf removeFromSuperview];
    }];
}
-(void)showInView:(UIView *)view{
    self.frame = view.bounds;
    self.backgroundColor = [UIColor clearColor];
    [self createViewWithWidth:view.frame.size.width];
    view.clipsToBounds = YES;
    [view addSubview:self];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (animating) {
        return;
    }
    [self removeSelf];
}
- (void)dealloc
{
    DEALLOC_PRINT;
}
@end
