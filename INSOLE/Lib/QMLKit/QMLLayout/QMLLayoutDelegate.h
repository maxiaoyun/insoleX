//
//  QMLLayoutDelegate.h
//  testQMLKit
//
//  Created by Myron on 14/12/17.
//  Copyright (c) 2014年 Myron. All rights reserved.
//

#ifndef testQMLKit_QMLLayoutDelegate_h
#define testQMLKit_QMLLayoutDelegate_h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QMLDefine.h"

@protocol QMLLayoutDelegate <NSObject>
@required
@property(nonatomic,copy)NSString *flag;
+(id)createWithInfoDict:(NSDictionary*)infoDict;
@optional
@end
#endif
