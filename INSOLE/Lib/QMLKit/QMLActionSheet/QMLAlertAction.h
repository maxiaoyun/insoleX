//
//  QMLAlertAction.h
//  USENSE
//
//  Created by Myron on 16/2/23.
//  Copyright © 2016年 Myron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMLObj.h"
typedef void(^QMLAlertHandle)(int index);
@interface QMLAlertAction :QMLObj
@property(nonatomic,readonly)NSAttributedString *title;
@property(nonatomic,readonly)QMLAlertHandle handle;
-(id)initWithTitle:(NSString *)title handle:(QMLAlertHandle)handle;
-(id)initWithAttributedTitle:(NSAttributedString *)attributedTitle handle:(QMLAlertHandle)handle;
@end
