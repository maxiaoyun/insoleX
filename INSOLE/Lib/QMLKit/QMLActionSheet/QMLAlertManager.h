//
//  QMLAlertManager.h
//  USENSE
//
//  Created by Myron on 16/2/23.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import "QMLObj.h"
#import "QMLAlertView.h"
@interface QMLAlertManager : QMLObj
+(QMLAlertManager *)sharedManger;
-(void)addAlert:(QMLAlertView *)alert;
-(void)showAlert;
-(void)dismissAlert;
@end
