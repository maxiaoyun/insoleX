//
//  UIScrollView+ref.m
//  testQMLKit
//
//  Created by Myron on 15/7/31.
//  Copyright (c) 2015年 Myron. All rights reserved.
//

#import "UIScrollView+ref.h"
#import <objc/runtime.h>
#import "QMLProgressView.h"

@interface QMLRefView ()
{
    QMLProgressView *proView;
    UILabel *proLa;
    UIActivityIndicatorView *animationView;
}
@end
@implementation QMLRefView
@synthesize status = _status,pullProgess = _pullProgess;
-(void)setStatus:(UBCStatus)status{
    _status = status;
    [self refView];
}
-(void)setPullProgess:(float)pullProgess{
    _pullProgess = pullProgess;
    [self refView];
    
}
-(void)refView{
    if (!proView) {
        proView = [[QMLProgressView alloc] initWithFrame:CGRectMake((self.frame.size.width-40)/2, 0, 40, 40)];
        proView.flag = @"proview_proview";
        proView.type = QMLProgressViewRound;
        proView.borderType = QMLProgressViewBorderTypeRound;
        proView.defaultColor = [UIColor clearColor];
        proView.progressColor = COLOR_WITH_RGB(249, 98, 98);
        proView.backgroundColor=[UIColor clearColor];
        proView.progressWidth=3;
        proView.progress=0.0;
        [self addSubview:proView];
        
        proLa =[[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-40)/2, 0, 40, 40)];
        proLa.textAlignment = NSTextAlignmentCenter;
        proLa.textColor = COLOR_WITH_RGB(249, 98, 98);
        proLa.tag = 1;
        proLa.font = [UIFont systemFontOfSize:10];
        proLa.backgroundColor = [UIColor clearColor];
        [self addSubview:proLa];
        
        
        animationView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        animationView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        animationView.color = COLOR_WITH_RGB(249, 98, 98);
        animationView.tag = 2;
        animationView.hidden = YES;
        [self addSubview:animationView];
    }
    
    proView.progress = self.pullProgess;
    proLa.text = [NSString stringWithFormat:@"%d%@",(int)(proView.progress*100),@"%"];
    
    if (self.status.dragging) {
        proView.hidden            = NO;
        proLa.hidden              = NO;
    }else{
        proView.hidden            = YES;
        proLa.hidden              = YES;
    }
    if (self.status.loading) {
        animationView.hidden      = NO;
        [animationView startAnimating];
    }else{
        animationView.hidden      = YES;
    }
    
}
@end

static char *s_status_UIScrollView_ref_pro_key = "s_status_UIScrollView_ref_pro_key";
static char *s_ref_action_UIScrollView_pro_key = "s_ref_action_UIScrollView_pro_key";
static char *s_should_pull_up_action_UIScrollView_pro_key = "s_should_pull_up_action_UIScrollView_pro_key";
static char *s_should_pull_down_action_UIScrollView_pro_key = "s_should_pull_down_action_UIScrollView_pro_key";
static char *s_pull_up_action_UIScrollView_pro_key = "s_pull_up_action_UIScrollView_pro_key";

@implementation UIScrollView (ref)
@dynamic refAction;
@dynamic status;
@dynamic shouldPullUpAction;
@dynamic pullUpAction;
-(void)setPullUpAction:(void (^)())pullUpAction{
    [self willChangeValueForKey:@"pullUpAction"];
    objc_setAssociatedObject(self, s_pull_up_action_UIScrollView_pro_key, pullUpAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"pullUpAction"];
}
-(void (^)())pullUpAction{
    return objc_getAssociatedObject(self, s_pull_up_action_UIScrollView_pro_key);
}
-(void)setShouldPullUpAction:(BOOL)shouldPullUpAction{
    BOOL should = self.shouldPullUpAction;
    [self willChangeValueForKey:@"shouldPullUpAction"];
    objc_setAssociatedObject(self, s_should_pull_up_action_UIScrollView_pro_key, @(shouldPullUpAction), OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"shouldPullUpAction"];
    
    unsigned char status =[self status];
    UBCStatus *statusRef = (UBCStatus *)(&status);
//    if (should&&!shouldPullUpAction) {
//        statusRef->isLast = 1;
//    }
    statusRef->isLast = 1;
    if (shouldPullUpAction) {
        statusRef->isLast = 0;
    }
    
    self.status = *((unsigned char*)statusRef);
    
    
    [self pullUpRefView].frame = CGRectMake(0, self.contentSize.height+10, self.frame.size.width, 40);
    [self pullUpRefView].status = *statusRef;
}
-(BOOL)shouldPullUpAction{
    id status = objc_getAssociatedObject(self, s_should_pull_up_action_UIScrollView_pro_key);
    if (status) {
        return [status boolValue];
    }
    return NO;
}
-(void)setShouldPullDownAction:(BOOL)shouldPullDownAction{
    [self willChangeValueForKey:@"shouldPullDownAction"];
    objc_setAssociatedObject(self, s_should_pull_down_action_UIScrollView_pro_key, @(shouldPullDownAction), OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"shouldPullDownAction"];
}
-(BOOL)shouldPullDownAction{
    id status = objc_getAssociatedObject(self, s_should_pull_down_action_UIScrollView_pro_key);
    if (status) {
        return [status boolValue];
    }
    return NO;
}
-(void)setStatus:(unsigned char)status{
    [self willChangeValueForKey:@"status"];
    objc_setAssociatedObject(self, s_status_UIScrollView_ref_pro_key, @(status), OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"status"];
}
-(unsigned char)status{
    id status = objc_getAssociatedObject(self, s_status_UIScrollView_ref_pro_key);
    if (status) {
        return [status unsignedCharValue];
    }
    return 0;
}
-(void)setRefAction:(void (^)())refAction{
    [self willChangeValueForKey:@"refAction"];
    objc_setAssociatedObject(self, s_ref_action_UIScrollView_pro_key, refAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"refAction"];
}
-(void (^)())refAction{
    return objc_getAssociatedObject(self, s_ref_action_UIScrollView_pro_key);
}
-(void)addPullUpRefView:(QMLRefView *)view{
    unsigned char status =[self status];
    UBCStatus *statusRef = (UBCStatus *)(&status);
    if (statusRef->addObserverAlready==0) {
        [self addObserver];
        statusRef -> addObserverAlready = 1;
        self.status = *((unsigned char*)statusRef);
    }
    if (![self pullUpRefView]) {
        if (!view) {
            view = [[QMLRefView alloc] initWithFrame:CGRectMake(0, self.contentSize.height+10, self.frame.size.width, 40)];
        }
        view.status = *statusRef;
        view.flag = @"scrollView_pullUpRefView";
        [self addSubview:view];
    }
}
-(void)addCustomRefView:(QMLRefView *)view{
    self.shouldPullDownAction = YES;
    unsigned char status =[self status];
    UBCStatus *statusRef = (UBCStatus *)(&status);
    if (statusRef->addObserverAlready==0) {
        [self addObserver];
        statusRef -> addObserverAlready = 1;
        self.status = *((unsigned char*)statusRef);
    }
    if (![self refView]) {
        if (!view) {
            view = [[QMLRefView alloc] initWithFrame:CGRectMake(0, -50, self.frame.size.width, 40)];
        }
        view.status = *statusRef;
        view.flag = @"scrollView_proview";
        [self addSubview:view];
    }
}
-(void)addRefView{
    self.shouldPullDownAction = YES;
    [self addCustomRefView:nil];
}
-(QMLView<QMLRefProtocol> *)pullUpRefView{
    for (QMLView *view in self.subviews) {
        if ([view isKindOfClass:[QMLView class]]&&[view.flag isEqualToString:@"scrollView_pullUpRefView"]) {
            return (QMLView<QMLRefProtocol> *)view;
        }
    }
    return nil;
}
-(QMLView<QMLRefProtocol> *)refView{
    for (QMLView *view in self.subviews) {
        if ([view isKindOfClass:[QMLView class]]&&[view.flag isEqualToString:@"scrollView_proview"]) {
            return (QMLView<QMLRefProtocol> *)view;
        }
    }
    return nil;
}
-(void)beginRef:(float)top{
    unsigned char status =[self status];
    UBCStatus *statusRef = (UBCStatus *)(&status);
    if (statusRef->loading==1) {
        return;
    }
    
    NSLog(@"刷新刷新刷新%d_%d",status,statusRef->loading);
    
    [UIView animateWithDuration:.25 animations:^{
        self.contentInset=UIEdgeInsetsMake(top,0.0f, 0.0f, 0.0f);
    }];
    
    //刷新回调
    void (^refFun)() = self.refAction;
    if (refFun) {
        refFun();
    }
}
-(void)beginPullUpRef:(float)bottom{
    unsigned char status =[self status];
    UBCStatus *statusRef = (UBCStatus *)(&status);
    if (statusRef->loading==1) {
        return;
    }
    
    
    
    [UIView animateWithDuration:.25 animations:^{
        self.contentInset=UIEdgeInsetsMake(0.0f,0.0f, bottom, 0.0f);
    }];
    
    //刷新回调
    void (^refFun)() = self.pullUpAction;
    if (refFun) {
        refFun();
    }
}
-(void)endPullUpRef:(float)bottom{
    unsigned char status =[self status];
    UBCStatus *statusRef = (UBCStatus *)(&status);
    statusRef->loading = 0;
    self.status = *((unsigned char*)statusRef);
    [self pullUpRefView].status = *statusRef;
    
    [UIView animateWithDuration:.25 animations:^{
        self.contentInset=UIEdgeInsetsMake(0.0f,0.0f, bottom, 0.0f);
    }];
}

-(void)endRef:(float)top{
    unsigned char status =[self status];
    UBCStatus *statusRef = (UBCStatus *)(&status);
    statusRef->loading = 0;
    self.status = *((unsigned char*)statusRef);
    [self refView].status = *statusRef;
    
    [UIView animateWithDuration:.25 animations:^{
        self.contentInset=UIEdgeInsetsMake(top,0.0f, 0.0f, 0.0f);
    }];
}
-(void)removeRefView{
    unsigned char status =[self status];
    UBCStatus *statusRef = (UBCStatus *)(&status);
    if (statusRef->addObserverAlready==1){
        [self removeObserver:self forKeyPath:@"contentOffset"];
        [self removeObserver:self forKeyPath:@"contentSize"];
        statusRef->addObserverAlready = 0;
    }
    
}
-(void)addObserver{
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentSize"]){
        [self pullUpRefView].frame = CGRectMake(0, self.contentSize.height+10, self.frame.size.width, 40);
        return;
    }
    
    unsigned char status =[self status];
    UBCStatus *statusRef = (UBCStatus *)(&status);
    
    
    if (statusRef->loading==1) {
        return;
    }
    
    NSValue *value = [change objectForKey:NSKeyValueChangeNewKey];
    float y = [value CGPointValue].y;
    float pro = (-y-30)/50;
    if (-y-30<0) {
        pro = 0;
    }
    
    if (y>0&&self.shouldPullUpAction){
        pro = (y - (self.contentSize.height - self.frame.size.height) - 30)/50;
        if (pro>=1.0f) {
            statusRef->shouldRef = 1;
        }else{
            statusRef->shouldRef = 0;
        }
        
        
        if (self.dragging) {
            statusRef->dragging = 1;
        }else{
            if (statusRef->dragging == 1&&statusRef -> shouldRef&&statusRef->loading!=1) {
                statusRef -> dragging = 0;
                self.status = *((unsigned char*)statusRef);
                [self beginPullUpRef:80];
                statusRef->loading = 1;
            }
            statusRef -> dragging = 0;
        }
        
        
        self.status = *((unsigned char*)statusRef);
        
        [self pullUpRefView].frame = CGRectMake(0, self.contentSize.height+10, self.frame.size.width, 40);
        [self pullUpRefView].pullProgess = pro;
        [self pullUpRefView].status = *statusRef;
    }else{
        if (self.shouldPullDownAction){
            if (pro>=1.0f) {
                statusRef->shouldRef = 1;
            }else{
                statusRef->shouldRef = 0;
            }
            
            if (self.dragging) {
                statusRef->dragging = 1;
            }else{
                if (statusRef->dragging == 1&&statusRef -> shouldRef == 1&&statusRef->loading!=1) {
                    statusRef -> dragging = 0;
                    self.status = *((unsigned char*)statusRef);
                    [self beginRef:80];
                    statusRef->loading = 1;
                }
                statusRef -> dragging = 0;
            }
        }
        self.status = *((unsigned char*)statusRef);
        [self refView].pullProgess = pro;
        [self refView].status = *statusRef;
    }
}
@end
