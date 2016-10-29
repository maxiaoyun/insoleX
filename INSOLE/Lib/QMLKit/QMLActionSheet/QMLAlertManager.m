//
//  QMLAlertManager.m
//  USENSE
//
//  Created by Myron on 16/2/23.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLAlertManager.h"
@interface QMLAlertManager()
{
    NSMutableArray *alertArr;
    BOOL showAlerting;
    QMLView *maskView;
}
@property(nonatomic,QML_DEFINE_PRO_RETAIN)QMLAlertView *alert;
@property(nonatomic,QML_DEFINE_PRO_RETAIN)QMLView *cntView;
@end
@implementation QMLAlertManager
+(QMLAlertManager *)sharedManger{
    static dispatch_once_t onceToken;
    static QMLAlertManager *S_QML_alertManager = nil;
    dispatch_once(&onceToken, ^{
        S_QML_alertManager = [[QMLAlertManager alloc]init];
    });
    return S_QML_alertManager;
}
-(void)setupDefineValues{
    [super setupDefineValues];
    alertArr = [NSMutableArray array];
}
-(void)addAlert:(QMLAlertView *)alert{
    [alertArr addObject:alert];
}
-(void)dismissAlertFinished{
    [self.cntView removeFromSuperview];
    self.cntView = nil;
    showAlerting = NO;
    [self showAlert];
}
-(void)dismissAlert{
    __weak typeof(self)bSelf = self;
    showAlerting = NO;
    [UIView animateWithDuration:.25 animations:^{
        bSelf.cntView.alpha = 0;
    } completion:^(BOOL finished) {
        [bSelf dismissAlertFinished];
    }];
}
-(void)maskViewDismiss{
    showAlerting = NO;
}
-(void)showAlert{
    if (showAlerting) {
        return;
    }
//    for (QMLView *vi in [[UIApplication sharedApplication] keyWindow].subviews) {
//        if ([vi isKindOfClass:[QMLView class]]&&[vi.flag isEqualToString:@"QMLAlertViewMaskView"]) {
//            return;
//        }
//    }
    showAlerting = NO;
    if (alertArr.count>0) {
        [self showAlert:alertArr[0]];
        [alertArr removeObjectAtIndex:0];
    }else{
        [maskView removeFromSuperview];
        self.cntView = nil;
        self.alert = nil;
        maskView = nil;
    }
}
-(void)showAlert:(QMLAlertView *)alert{
    showAlerting = NO;
    self.alert = alert;
    self.cntView = [self.alert draw];
    if (self.cntView) {
        showAlerting = YES;
        if (!maskView) {
            maskView = [[QMLView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            maskView.flag = @"QMLAlertViewMaskView";
            maskView.backgroundColor = [UIColor clearColor];
            [[[UIApplication sharedApplication] keyWindow] addSubview:maskView];
        }
        typeof(self)bSelf = self;
        maskView.willMoveToSuperview = ^(UIView *newSuperView){
            if (!newSuperView) {
                [bSelf maskViewDismiss];
            }
        };
        
        [maskView addSubview:self.cntView];
        float w = maskView.frame.size.width;
        float v_h = self.cntView.frame.size.height;
        float h = maskView.frame.size.height;
        float span = 50;
        switch (self.alert.position) {
            case QMLPositionTop:
                self.cntView.center = CGPointMake(w/2, span + v_h/2);
                break;
            case QMLPositionCenter:
                self.cntView.center = CGPointMake(w/2, h/2);
                break;
            case QMLPositionBottom:
                self.cntView.center = CGPointMake(w/2, h - span - v_h/2);
                break;
                
            default:
                break;
        }
        self.cntView.alpha = 0;
        [UIView animateWithDuration:.25 animations:^{
            bSelf.cntView.alpha = 1;
        } completion:nil];
        
        if(self.alert.autoDismiss){
            maskView.userInteractionEnabled = NO;
            [self performSelector:@selector(dismissAlert) withObject:nil afterDelay:1];
        }else{
            maskView.userInteractionEnabled = YES;
            maskView.backgroundColor = COLOR_WITH_RGBA(0, 0, 0, 255*.6);
        }
    }
}
@end
